class MoviesController < ApplicationController
  require 'uri'
  require 'net/http'

  def index
    render "index"
  end

  def search
    # query = params[:query]

    #if query.present?
    #  if duplicate_search?(query)
    #    puts 'volt ilyen query az elmult 2 percben'
    #    return
    #  end
    #end

    render plain: "oke", status: :forbidden
  end

  private
  def duplicate_search?(query)
    etag = generate_etag(query)

    if stale?(etag: etag, public: true)
      update_etag(query, etag)
      return false
    else
      return true
    end
  end

  def generate_etag(query)
    Digest::MD5.hexdigest(query.to_s)
  end

  def update_etag(query, etag)
    Rails.cache.write("search_query_#{query}", etag, expires_in: 2.minutes)
  end

  def get_movies(query)
    url = URI("https://api.themoviedb.org/3/search/movie?include_adult=false&language=en-US&page=1&query=#{URI.encode_www_form_component(query)}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZDAzMGMxMjdiNzEyMTQ5MGMwNWE0YjAzY2ExYTc2ZCIsInN1YiI6IjY2MjIyODdiZWNjN2U4MDE0YmUzNTg5NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.y0JVPOhg0drYM4FFqh3Ac3Z9WSr_t529PglrGLRp8mk'

    response = http.request(request)
    return response.body
  end
end