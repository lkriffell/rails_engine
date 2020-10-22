class Api::V1::SearchController < ApplicationController
  def index
    search_query
  end

  def show
    search_query
  end

  private

    def search_query
      search_param = request.query_parameters.first
      attribute = search_param.first
      value = search_param.last.gsub("'", "''")
      query = "LOWER(#{attribute}) LIKE LOWER('%#{value}%')"
      if params['resource'] == 'merchants'
        results = Merchant.where("#{query}")
        return_based_on_merchant(params["action"], results)
      elsif params['resource'] == 'items' && value.count("a-zA-Z") > 0
        results = render json: Item.where("#{query}")
        return_based_on_item(params["action"], results)
      elsif value.to_i
        results = Item.where("#{attribute}": value)
        return_based_on_item(params["action"], results)
      end
    end

    def return_based_on_merchant(action, results)
      if action == 'index'; render json: MerchantSerializer.new(results)
      else render json: MerchantSerializer.new(results.first)
      end
    end

    def return_based_on_item(action, results)
      if action == 'index'; render json: ItemSerializer.new(results)
      else render json: ItemSerializer.new(results.first)
      end
    end
end
