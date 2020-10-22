class Api::V1::RevenueController < ApplicationController
  def index
    limit = request.query_parameters.first.last.to_i
    render json: MerchantSerializer.new(Merchant.top_revenue(limit))
  end

  def show
    limit = request.query_parameters.first.last.to_i
    render json: MerchantSerializer.new(Merchant.most_items_sold(limit))
  end
end
