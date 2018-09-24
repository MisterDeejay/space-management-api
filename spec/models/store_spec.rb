require 'rails_helper'

RSpec.describe Store, type: :model do
  # Association test
  it { should have_many(:spaces).dependent(:destroy) }
  # Validation tests
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:street) }
  it { should validate_presence_of(:spaces_count) }

  describe '#spaces_count_at_max' do
    let(:store) { FactoryBot.create(:store, spaces_count: 2) }

    context 'spaces_count not at max' do
      it 'return false' do
        expect(store.spaces_count_at_max?).to be_falsey
      end
    end

    context 'spaces_count at max' do
      before do
        FactoryBot.create(:space, store_id: store.id)
        FactoryBot.create(:space, store_id: store.id)
      end

      it 'returns true' do
        expect(store.spaces_count_at_max?).to be_truthy
      end
    end
  end
end
