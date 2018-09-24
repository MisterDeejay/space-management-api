require 'rails_helper'

RSpec.describe 'Items API' do
  # Initialize the test data
  let!(:store) { create(:store, spaces_count: 30) }
  let!(:spaces) { create_list(:space, 20, store_id: store.id) }
  let(:store_id) { store.id }
  let(:id) { spaces.first.id }

  # Test suite for GET /stores/:store_id/spaces/
  describe 'GET /stores/:store_id/spaces' do
    context 'when the store exists' do
      context 'without query params' do
        before { get "/stores/#{store_id}/spaces/" }

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns all space records' do
          expect(json.size).to eq(20)
        end
      end

      context 'with query params' do
        let(:query_param) { "Elm" }
        let!(:space_1) { FactoryBot.create(:space, title: "#{query_param}_1", store: store) }
        let!(:space_2) { FactoryBot.create(:space, title: "#{query_param}_2", store: store) }

        context 'correctly formed' do
          before { get "/stores/#{store_id}/spaces?title=like:#{query_param}" }

          it 'returns the matching records' do
            expect(json.count).to eq(2)

            titles = json.map { |s| s['title'] }
            expect(titles.include?(space_1.title)).to be_truthy
            expect(titles.include?(space_2.title)).to be_truthy
          end
        end

        context 'incorrectly formed' do
          before { get "/stores/#{store_id}/spaces?title=between:#{query_param}" }

          it 'returns status code 404' do
            expect(response).to have_http_status(422)
          end

          it 'returns a query finder error' do
            expect(response.body).to match(/Query failed: Comparison operator does not exist/)
          end
        end
      end
    end

    context 'when the store does not exist' do
      let(:store_id) { 0 }
      before { get "/stores/#{store_id}/spaces" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Store/)
      end
    end
  end

  # Test suite for GET /stores/:store_id/spaces/:id
  describe 'GET /stores/:store_id/spaces/:id' do
    before { get "/stores/#{store_id}/spaces/#{id}" }

    context 'when the space exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the item' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when the space does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Space/)
      end
    end
  end

  describe 'GET stores/:store_id/spaces/:id/price/:start_date/:end_date' do
    let(:start_date) { '2017-09-01' }
    let(:end_date) { '2018-09-20' }
    before { get "/stores/#{store_id}/spaces/#{id}/price/#{start_date}/#{end_date}"}

    context 'with valid request params' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the correct price quote' do
        price_quote = CostCalculator.new(
          spaces.first,
          { start_date: start_date, end_date: end_date }
        ).run

        expect(json['price_quote']).to eq(price_quote.to_s)
      end
    end

    context 'with invalid date params' do
      let(:start_date) { '2017-09-100' }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return a price calculator error' do
        expect(response.body).to match(/invalid date/)
      end
    end

    context 'start date is not before end date' do
      let(:start_date) { '2018-09-20' }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns price calculator error' do
        expect(response.body).to match(/DateInvalid: Start date must occur before end date/)
      end
    end

    context 'when the space does not exist' do
      let(:id) { 0 }

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Space/)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'when the store does not exist' do
      let(:store_id) { 0 }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Store/)
      end
    end
  end

  # Test suite for PUT /stores/:store_id/spaces
  describe 'POST /stores/:store_id/spaces' do
    let(:valid_attributes) {
      {
        title: 'Visit Narnia',
        size: BigDecimal.new('15.15'),
        price_per_day: BigDecimal.new('10.0'),
        price_per_week: BigDecimal.new('60.0'),
        price_per_month: BigDecimal.new('280.0')
      }
    }

    context 'when request attributes are valid' do
      before { post "/stores/#{store_id}/spaces", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      context 'when the number of spaces being created exceeds the store space_count' do
        let(:store) { FactoryBot.create(:store, spaces_count: 20) }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a failure message' do
          store = Store.find(store_id)
          expect(response.body).to match(/Space creation failed: Spaces count cannot exceed max/)
        end
      end
    end

    context 'when an invalid request' do
      before { post "/stores/#{store_id}/spaces", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  # Test suite for PUT /stores/:store_id/spaces/:id
  describe 'PUT /stores/:store_id/space/:id' do
    let(:valid_attributes) { { title: 'Mozart' } }

    before { put "/stores/#{store_id}/spaces/#{id}", params: valid_attributes }

    context 'when the space exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the space' do
        updated_space = Space.find(id)
        expect(updated_space.title).to match(/Mozart/)
      end
    end

    context 'when the space does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Space/)
      end
    end
  end

  # Test suite for DELETE /spaces/:id
  describe 'DELETE /spaces/:id' do
    it 'returns status code 204' do
      delete "/stores/#{store_id}/spaces/#{id}"

      expect(response).to have_http_status(204)
    end

    it 'delete the space record' do
      expect {
        delete "/stores/#{store_id}/spaces/#{id}"
      }.to change { Space.count }.by(-1)
    end
  end
end
