class MoviesController < ApplicationController
  include ApplicationHelper

  require 'uri'
  require 'net/http'

  def index
    render "index"
  end

  def search
     query = params[:query]
     @url = request.path
     @current_page = params[:page].to_i.positive? ? params[:page].to_i : 1
     puts @current_page

     if query.present?
       response = get_movies(query, @current_page)
       movies_data = JSON.parse(response)
       @movies = movies_data['results'].select { |movie| movie['poster_path'].present? }
       @total_pages = movies_data['total_pages']

       if @current_page.to_i > @total_pages.to_i
         redirect_to "#{@url}?query=#{query}&page=#{@total_pages}"
         return
       end
       @pages = pagination(@current_page.to_i, @total_pages.to_i)
     end

    render "index"
  end

  private
  def get_url
    base_url + original_fullpath
  end

  def get_movies(query, page = 1)
    url = URI("https://api.themoviedb.org/3/search/movie?include_adult=false&language=en-US&page=#{page}&query=#{URI.encode_www_form_component(query)}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZDAzMGMxMjdiNzEyMTQ5MGMwNWE0YjAzY2ExYTc2ZCIsInN1YiI6IjY2MjIyODdiZWNjN2U4MDE0YmUzNTg5NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.y0JVPOhg0drYM4FFqh3Ac3Z9WSr_t529PglrGLRp8mk'

    response = http.request(request)
    return response.body
  end
end