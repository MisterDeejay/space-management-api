module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from ::Exceptions::SpacesCountExceeded do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from ::Exceptions::QueryFinderError::OperationInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from ::Exceptions::CostCalculatorError::DateInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end
  end
end
