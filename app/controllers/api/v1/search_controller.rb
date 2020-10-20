class Api::V1::SearchController < ApplicationController
  def index
    search_param = request.query_parameters.first
    attribute = search_param.first
    value = search_param.last.gsub("'", "''")
    query = "LOWER(#{attribute}) LIKE LOWER('%#{value}%')"
    if params['resource'] == 'merchants'
      render json: MerchantSerializer.new(Merchant.where("#{query}"))
    elsif params['resource'] == 'items' && value.count("a-zA-Z") > 0
      render json: ItemSerializer.new(Item.where("#{query}"))
    elsif value.to_i
      render json: ItemSerializer.new(Item.where("#{attribute}": value))
    end
  end

  def show
    search_param = request.query_parameters.first
    attribute = search_param.first
    value = search_param.last.gsub("'", "''")
    query = "LOWER(#{attribute}) LIKE LOWER('%#{value}%')"
    if params['resource'] == 'merchants'
      render json: MerchantSerializer.new(Merchant.where("#{query}").first)
    elsif params['resource'] == 'items' && value.count("a-zA-Z") > 0
      render json: ItemSerializer.new(Item.where("#{query}").first)
    elsif value.to_i
      render json: ItemSerializer.new(Item.find_by("#{attribute}": value))
    end
  end
end
