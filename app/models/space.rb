class Space < ApplicationRecord
  belongs_to :store

  validates_presence_of :title, :size, :price_per_day, :price_per_week, :price_per_month
end
