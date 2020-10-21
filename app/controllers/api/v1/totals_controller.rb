class Api::V1::TotalsController < ApplicationController
  def index
    start_date = request.query_parameters['start']
    stop_date = request.query_parameters['end']
    total_revenue = Merchant.total_revenue(start_date, stop_date)
    render json: revenue_serializer(total_revenue)
  end

  def show
    merchant = Merchant.find(params["merchant_id"])
    render json: MerchantSerializer.new(merchant)
  end

  private

    def revenue_serializer(revenue)
      {
        "data": {
          "attributes": {
            "revenue": revenue
          }
        }
      }
    end
end
