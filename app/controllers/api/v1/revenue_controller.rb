class Api::V1::RevenueController < ApplicationController
  def index
    limit = request.query_parameters.first.last.to_i
    revenues = Merchant.top_revenue(limit)
    render json: MerchantSerializer.new(revenues)
  end

  def show
    limit = request.query_parameters.first.last.to_i
    merchants = Merchant.most_items_sold(limit)
    render json: MerchantSerializer.new(merchants)
  end
end
