class AddIndexOnSpacesTitleAndStoreId < ActiveRecord::Migration[5.2]
  def change
    add_index :spaces, [:title, :store_id], unique: true
  end
end
