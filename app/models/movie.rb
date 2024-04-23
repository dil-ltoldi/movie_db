class Movie < ApplicationRecord
  include ApplicationHelper

  def list
    parsed_data = JSON.parse(response)
    parsed_data['results']
  end

  def total_pages
    parsed_data = JSON.parse(response)
    parsed_data['total_pages']
  end

  def pages
    pagination(page, total_pages)
  end
end
