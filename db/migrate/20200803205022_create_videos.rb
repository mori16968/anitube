class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.date :date
      t.string :thumbnail, null: false

      t.timestamps
    end
  end
end
