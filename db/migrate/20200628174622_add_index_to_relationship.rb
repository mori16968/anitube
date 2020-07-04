class AddIndexToRelationship < ActiveRecord::Migration[5.2]
  def change
    add_index :relationships, :following_id
    add_index :relationships, :follower_id
    add_index :relationships, [:following_id, :follower_id], unique: true
  end
end
