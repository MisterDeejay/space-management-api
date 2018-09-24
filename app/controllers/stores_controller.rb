class StoresController < ApplicationController
  before_action :set_store, only: [:show, :update, :destroy]
  before_action :set_stores, only: [:index]

  # GET /stores
  def index
    json_response(@stores)
  end

  # POST /stores
  def create
    @store = Store.create!(store_params)
    json_response(@store, :created)
  end

  # GET /stores/:id
  def show
    json_response(@store)
  end

  # PUT /stores/:id
  def update
    @store.update(store_params)
    head :no_content
  end

  # DELETE /stores/:id
  def destroy
    @store.destroy
    head :no_content
  end

  private

  def store_params
    params.permit(:title, :city, :street, :spaces_count)
  end

  def set_store
    @store = Store.find(params[:id])
  end

  def set_stores
    @stores = if store_params.present?
      QueryFinder.new('Store', store_params).run
    else
      Store.all
    end
  end
end
