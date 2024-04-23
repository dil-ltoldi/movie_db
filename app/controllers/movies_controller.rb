class MoviesController < ApplicationController
  include ApplicationHelper

  def index
    render "index"
  end

  def search
     query = params[:query]
     @url = request.path
     @current_page = params[:page].to_i.positive? ? params[:page].to_i : 1

     movie = Movie.find_by(query: query, page: @current_page)

     if movie.present? && ((Time.now - movie.created_at) <= 120)
       movie.with_lock do
         movie.increment!(:hit_count)
       end
       @movies = movie.data
       @total_pages = movie.total_pages
       @hit_count = movie.hit_count
     else
       if movie.present?
         movie.delete
       end
       response = TmdbClient.get_movies(query, @current_page)
       Movie.create(query: query, response: response, page: @current_page, hit_count: 0)
       movie = Movie.find_by(query: query, page: @current_page)
       if movie.present?
         puts movie.hit_count
         @movies = movie.data
         @total_pages = movie.total_pages
         @hit_count = movie.hit_count
       else
         flash[:error] = "No movie data found for the given query."
         redirect_to root_path
         return
       end
     end

     if @current_page > @total_pages
       redirect_to "#{@url}?query=#{query}&page=#{@total_pages}"
       return
     end

     @pages = pagination(@current_page, @total_pages)

     render "index"
  end

  private
  # Separate class for example: TMDBClient
  #   * error handling
  #   * use config for url and other neccessary data
  #   * double check the parameter injection
  #   * strong(default) parameters,
  #   * DO NOT STORE SECRETS IN THE CODE AT ALL, EVEN NOT COMMIT IT TO GITHUB(.env gem, environment variables, or rails secret)
end