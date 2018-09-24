require 'rails_helper'

describe QueryFinder do
  describe '#run' do
    let(:title) { 'Elm St' }
    let!(:record) {
      FactoryBot.create(:space, title: title, store: FactoryBot.create(:store))
    }
    let(:query_finder) { QueryFinder.new(record.class.to_s, query_params) }
    before {
      FactoryBot.create(:space, title:'Wally', store: FactoryBot.create(:store))
    }

    context 'with proper query params' do
      let(:query_params) {
        { title: "eq:#{title}" }
      }

      it 'returns the correct records' do
        records = query_finder.run

        expect(records.count).to eq(1)
        expect(records.include?(record)).to be_truthy
      end
    end

    context 'with ILIKE query operator' do
      let(:query_params) {
        { title: "like:Elm" }
      }

      it 'wraps query param value in percentage signs to properly execute query' do
          records = query_finder.run

          expect(records.count).to eq(1)
          expect(records.include?(record)).to be_truthy
      end
    end
  end
end
