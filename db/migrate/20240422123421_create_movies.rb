class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :query
      t.string :response
      t.integer :page
      t.integer :hit_count

      t.timestamps
    end
    add_index :movies, :id
  end
end
