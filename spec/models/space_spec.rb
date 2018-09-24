require 'rails_helper'

RSpec.describe Space, type: :model do
  # Association test
  it { should belong_to(:store) }
  # Validation tests
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:size) }
  it { should validate_presence_of(:price_per_day) }
  it { should validate_presence_of(:price_per_week) }
  it { should validate_presence_of(:price_per_month) }
end
