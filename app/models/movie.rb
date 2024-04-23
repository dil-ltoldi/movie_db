class Movie < ApplicationRecord

  def data
    movies_data = JSON.parse(response)
    movies_data['results']
  end

  def total_pages
    response_data = JSON.parse(response)
    response_data['total_pages']
  end
end
