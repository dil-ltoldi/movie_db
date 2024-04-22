# open struct would be better
class Movie
  attr_accessor :adult, :backdrop_path, :genre_ids, :id, :original_language, :original_title, :overview, :popularity, :poster_path, :release_date, :title, :video, :vote_average, :vote_count

  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value) if respond_to?("#{key}=")
    end
  end
end