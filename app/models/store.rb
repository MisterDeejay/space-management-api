class Store < ApplicationRecord
  has_many :spaces, dependent: :destroy

  validates_presence_of :title, :city, :street, :spaces_count

  def spaces_count_at_max?
    spaces_count == spaces.count
  end
end
