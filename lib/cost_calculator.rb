class CostCalculator
  attr_accessor :space_cost

  def initialize(space, date_params)
    @space = space
    begin
      @start_date = Date.parse(date_params[:start_date])
      @end_date = Date.parse(date_params[:end_date])
    rescue ArgumentError => _e
      raise ::Exceptions::CostCalculatorError::DateInvalid.new(_e.message)
    end
  end

  def run
    total_days = @end_date - @start_date
    if total_days <= 0
      raise ::Exceptions::CostCalculatorError::DateInvalid.new(
        "DateInvalid: Start date must occur before end date"
      )
    end

    months = (total_days / 30.0).to_i
    weeks = ((total_days % 30) / 7.0).to_i
    days = ((total_days % 30) % 7).to_i
    space_cost = (@space.price_per_month * months)
      + (@space.price_per_week * weeks)
      + (@space.price_per_day * days)

    @space_cost = BigDecimal.new(space_cost)
  end
end
