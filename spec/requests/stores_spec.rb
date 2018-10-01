require 'rails_helper'

RSpec.describe 'Stores API', type: :request do
  let!(:stores) { create_list(:store, 10) }
  let(:store_id) { stores.first.id }

  describe 'GET /stores' do
    context 'without query params' do
      before { get '/stores' }

      it 'returns stores' do
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with query params' do
      let(:query_param) { "Elm" }
      let!(:store_1) { FactoryBot.create(:store, title: "#{query_param}_1") }
      let!(:store_2) { FactoryBot.create(:store, title: "#{query_param}_2") }

      context 'correctly formed' do
        before { get "/stores?title=like:#{query_param}" }

        it 'returns the matching records' do
          expect(json.count).to eq(2)

          titles = json.map { |s| s['title'] }
          expect(titles.include?(store_1.title)).to be_truthy
          expect(titles.include?(store_2.title)).to be_truthy
        end
      end

      context 'incorrectly formed' do
        before { get "/stores?title=between:#{query_param}" }

        it 'returns status code 404' do
          expect(response).to have_http_status(422)
        end

        it 'returns a query finder error' do
          expect(response.body).to match(/Query failed: Comparison operator does not exist/)
        end
      end
    end
  end

  # Test suite for GET /stores/:id
  describe 'GET /stores/:id' do
    before { get "/stores/#{store_id}" }

    context 'when the record exists' do
      it 'returns the store' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(store_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:store_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Store/)
      end
    end
  end

  # Test suite for POST /stores
  describe 'POST /stores' do
    # valid payload
    let(:valid_attributes) {
      {
        title: 'Elm',
        city: 'Los Angeles',
        street: '711 Wilshire Blvd',
        spaces_count: 6
      }
    }

    context 'when the request is valid' do
      before { post '/stores', params: valid_attributes }

      it 'creates a store' do
        expect(json['title']).to eq('Elm')
        expect(json['city']).to eq('Los Angeles')
        expect(json['street']).to eq('711 Wilshire Blvd')
        expect(json['spaces_count']).to eq(6)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/stores', params: { title: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: City can't be blank/)
      end
    end
  end

  # Test suite for PUT /stores/:id
  describe 'PUT /stores/:id' do
    let(:valid_attributes) { { title: 'Shopping' } }

    context 'when the record exists' do
      before { put "/stores/#{store_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to_not be_empty
        record = Store.find(store_id)
        expect(record.title).to eq('Shopping')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /stores/:id
  describe 'DELETE /stores/:id' do
    before { delete "/stores/#{store_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
