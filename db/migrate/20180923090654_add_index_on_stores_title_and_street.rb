class AddIndexOnStoresTitleAndStreet < ActiveRecord::Migration[5.2]
  def change
    add_index :stores, [:title, :street], unique: true
  end
end
