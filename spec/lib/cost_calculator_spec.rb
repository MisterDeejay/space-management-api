require 'rails_helper'

describe CostCalculator do
  describe '#run' do
    let(:space) { FactoryBot.create(:space, store: FactoryBot.create(:store)) }
    let(:calculator) { CostCalculator.new(space, date_params) }

    context 'with valid date params' do
      let!(:date_params) { { start_date: '2017-09-20', end_date: '2018-09-20' } }
      before { calculator.run }

      it 'returns a price quote' do
        total_days = Date.parse(date_params[:end_date]) - Date.parse(date_params[:start_date])
        months = (total_days / 30.0).to_i
        weeks = ((total_days % 30) / 7.0).to_i
        days = ((total_days % 30) % 7).to_i

        space_cost = (space.price_per_month * months)
          + (space.price_per_week * weeks)
          + (space.price_per_day * days)
        expect(calculator.space_cost).to eq(BigDecimal.new(space_cost))
      end
    end

    context 'invalid date params' do
      context 'the start date is not after the end date' do
        let!(:date_params) { { start_date: '2018-09-20', end_date: '2018-09-20' } }

        it 'raises a CostCalculatorError' do
          expect {
            calculator.run
          }.to raise_error(Exceptions::CostCalculatorError::DateInvalid)
        end
      end

      context 'the dates cannot be parsed' do
        let!(:date_params) { { start_date: '2018-09-200', end_date: '2018-09-20' } }

        it 'raises a CostCalculatorError' do
          expect {
            calculator.run
          }.to raise_error(Exceptions::CostCalculatorError::DateInvalid)
        end
      end
    end
  end
end
