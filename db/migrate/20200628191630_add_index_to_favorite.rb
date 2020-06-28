class AddIndexToFavorite < ActiveRecord::Migration[5.2]
  def change
    add_index :favorites, :user_id
    add_index :favorites, :post_id
    add_index :favorites, [:user_id, :post_id], unique: true
  end
end
