class TmdbClient
  require 'dotenv/load'

  require 'uri'
  require 'net/http'

  def self.get_movies(query, page = 1)
    url = URI("https://api.themoviedb.org/3/search/movie?include_adult=false&language=en-US&page=#{page}&query=#{URI.encode_www_form_component(query)}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["Authorization"] = ENV['TMDB_API_TOKEN']

    response = http.request(request)
    return response.body.force_encoding('UTF-8')
  end
end