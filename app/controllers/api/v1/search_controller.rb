class Api::V1::SearchController < ApplicationController
  def index
    search_param = request.query_parameters.first
    if params['resource'] == 'merchant'
      render json: Merchant.where("#{search_param.first} LIKE '#{search_param.last}'")
    elsif params['resource'] == 'item' && !search_param.last.to_i
      render json: Item.where("#{search_param.first} LIKE '#{search_param.last}'")
    elsif search_param.last.to_i
      render json: Item.where("#{search_param.first}": search_param.last)
    end
  end

  def show
    search_param = request.query_parameters.first
    if params['resource'] == 'merchant'
      render json: Merchant.find_by("#{search_param.first} LIKE '#{search_param.last}'")
    elsif params['resource'] == 'item' && !search_param.last.to_i
      render json: Item.find_by("#{search_param.first} LIKE '#{search_param.last}'")
    elsif search_param.last.to_i
      render json: Item.find_by("#{search_param.first}": search_param.last)
    end
  end
end
