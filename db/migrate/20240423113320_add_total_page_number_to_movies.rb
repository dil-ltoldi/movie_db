class AddTotalPageNumberToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :total_pages, :integer
  end
end
