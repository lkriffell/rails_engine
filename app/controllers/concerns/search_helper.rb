module SearchHelper
  def search
    search_param = request.query_parameters.first
    attribute = search_param.first
    value = search_param.last.gsub("'", "''")
    query = "LOWER(#{attribute}) LIKE LOWER('%#{value}%')"
    if params['resource'] == 'merchants'
      results = Merchant.where("#{query}")
      render_based_on_merchant(params["action"], results)
    elsif params['resource'] == 'items' && value.count("a-zA-Z") > 0
      results = Item.where("#{query}")
      render_based_on_item(params["action"], results)
    elsif value.to_i
      results = Item.where("#{attribute}": value)
      render_based_on_item(params["action"], results)
    end
  end

  def render_based_on_merchant(action, results)
    if action == 'index'
      render json: MerchantSerializer.new(results)
    elsif action == 'show'
      render json: MerchantSerializer.new(results.first)
    end
  end

  def render_based_on_item(action, results)
    if action == 'index'
      render json: ItemSerializer.new(results)
    elsif action == 'show'
      render json: ItemSerializer.new(results.first)
    end
  end

  def attribute_exists?
    attribute = request.query_parameters.first.first
    if Item.column_names.include?(attribute) || Merchant.column_names.include?(attribute)
      true
    else
      error_message = "#{attribute} is not an attribute of #{params['resource']}!"
      render json: error_serializer(error_message)
    end
  end

  def error_serializer(error)
    {
      "data": {
        "message": error
      }
    }
  end
end
