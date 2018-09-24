class CreateSpaces < ActiveRecord::Migration[5.2]
  def change
    create_table :spaces do |t|
      t.references :store, foreign_key: true
      t.string :title, null: false
      t.decimal :size, null: false
      t.decimal :price_per_day, null: false
      t.decimal :price_per_week, null: false
      t.decimal :price_per_month, null: false

      t.timestamps
    end
  end
end
