class SpacesController < ApplicationController
  before_action :set_store
  before_action :set_space, only: [:show, :update, :destroy, :price]
  before_action :validate_spaces_count, only: [:create]
  before_action :calculate_price_quote, only: [:price]

  # GET /stores/:store_id/spaces
  def index
    json_response(@store.spaces)
  end

  # GET /stores/:store_id/spaces/:id
  def show
    json_response(@space)
  end

  # POST /stores/:store_id/spaces
  def create
    @space = @store.spaces.create!(space_params)
    json_response(@space, :created)
  end

  # PUT /stores/:store_id/spaces/:id
  def update
    @space.update(space_params)
    head :no_content
  end

  # DELETE /stores/:store_id/spaces/:id
  def destroy
    @space.destroy
    head :no_content
  end

  def price
    json_response({ price_quote: @space_cost })
  end

  private

  def calculate_price_quote
    @space_cost = CostCalculator.new(@space, date_params).run
  end

  def date_params
    params.permit(:start_date, :end_date)
  end

  def validate_spaces_count
    raise ::Exceptions::SpacesCountExceeded.new if @store.spaces_count_at_max?
  end

  def space_params
    params.permit(:title, :size, :price_per_day, :price_per_week, :price_per_month)
  end

  def set_store
    @store = Store.find(params[:store_id])
  end

  def set_space
    @space = @store.spaces.find_by!(id: params[:id]) if @store
  end
end
