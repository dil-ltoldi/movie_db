class MoviesController < ApplicationController
  include ApplicationHelper

  def index
    render "index"
  end

  def search
     query = search_params[:query]
     page = search_params[:page].to_i.positive? ? search_params[:page].to_i : 1

     movie = Movie.find_by(query: query, page: page)

     if movie.present? && ((Time.now - movie.created_at) <= 120)
       movie.with_lock do
        movie.increment!(:hit_count)
       end
     else
        movie.delete if movie.present?

        response = TmdbClient.get_movies(query, page)
        movie = Movie.find_or_create_by(query: query, page: page) do |m|
         m.response = response
         m.hit_count = 0
       end
     end

     @movie = movie

     if movie.page > (movie.total_pages || 1)
       redirect_to "#{request.path}?query=#{query}&page=#{movie.total_pages || 1}"
       return
     end

     render "index"
  end

  private
  # Separate class for example: TMDBClient
  #   * error handling
  #   * use config for url and other neccessary data
  #   * double check the parameter injection
  #   * strong(default) parameters,
  #   * DO NOT STORE SECRETS IN THE CODE AT ALL, EVEN NOT COMMIT IT TO GITHUB(.env gem, environment variables, or rails secret)
  def search_params
    params.permit(:query, :page)
  end
end