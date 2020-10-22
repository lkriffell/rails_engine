require 'rails_helper'

describe "Items API" do
  before :each do
    @merchant = create :merchant
  end
  describe 'CRUD Endpoints' do
    it "sends a list of items" do
      create_list(:item, 3, merchant_id: @merchant.id)

      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data].count).to eq(3)
    end

    it "can get one item by its id" do
      id = create(:item, merchant_id: @merchant.id).id

      get "/api/v1/items/#{id}"

      item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(id.to_s).to eq(item[:data][:id])
    end

    it "can create a new item" do
      item_params = { name: 'Corvette',
                      description: 'A car',
                      unit_price: 47,
                      merchant_id: @merchant.id
                    }
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item_params)
      item = Item.last

      expect(response).to be_successful
      expect(item.name).to eq(item_params[:name])
      expect(item.description).to eq(item_params[:description])
      expect(item.unit_price).to eq(item_params[:unit_price])
      expect(item.merchant_id).to eq(item_params[:merchant_id])
      expect(item.merchant).to eq(@merchant)
    end

    it "can update an existing item" do
      id = create(:item, merchant_id: @merchant.id).id
      previous_name = Item.last.name
      item_params = { name: "Corvette", unit_price: 134, merchant_id: @merchant.id }
      headers = {"CONTENT_TYPE" => "application/json"}

      put "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item_params)
      item = Item.find(id)

      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq("Corvette")
      expect(item.unit_price).to eq(134)
      expect(item.merchant_id).to eq(@merchant.id)
    end

    it "can destroy an item" do
      item = create(:item, merchant_id: @merchant.id)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'Relationship Endpoint' do
    it "merchant can be found through item id" do
      item = create(:item, merchant_id: @merchant.id)

      expect(Item.count).to eq(1)

      get "/api/v1/items/#{item.id}/merchant"

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant).to be_a(Hash)
      expect(merchant[:data]).to be_an(Hash)
      expect(merchant[:data][:attributes][:name]).to eq(@merchant.name)
      expect(merchant[:data][:id]).to eq(@merchant.id.to_s)
    end
  end

  describe 'Search Endpoint' do
    it "can find an item through querying it's name" do
      item = create(:item, merchant_id: @merchant.id)

      get "/api/v1/item/find?name=#{item.name}"

      found_item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(found_item).to be_a(Hash)
      expect(found_item[:data]).to be_a(Hash)
      expect(item.name).to eq(found_item[:data][:attributes][:name])
      expect(item.description).to eq(found_item[:data][:attributes][:description])
      expect(item.unit_price).to eq(found_item[:data][:attributes][:unit_price])
      expect(item.merchant_id).to eq(found_item[:data][:attributes][:merchant_id])
    end

    it "can find an item through querying it's unit price" do
      item = create(:item, merchant_id: @merchant.id)

      get "/api/v1/item/find?unit_price=#{item.unit_price}"

      found_item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(found_item).to be_a(Hash)
      expect(item.name).to eq(found_item[:data][:attributes][:name])
      expect(item.description).to eq(found_item[:data][:attributes][:description])
      expect(item.unit_price).to eq(found_item[:data][:attributes][:unit_price])
      expect(item.merchant_id).to eq(found_item[:data][:attributes][:merchant_id])
    end

    it "can find all items with a similar name" do
      item1 = create(:item, name: 'whoopie cushion',merchant_id: @merchant.id)
      item2 = create(:item, name: 'couch cushion', merchant_id: @merchant.id)

      get "/api/v1/items/find_all?name=cushion"

      found_items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(found_items).to be_a(Hash)
      expect(found_items[:data]).to be_an(Array)

      expect(item1.name).to eq(found_items[:data].first[:attributes][:name])
      expect(item1.description).to eq(found_items[:data].first[:attributes][:description])
      expect(item1.unit_price).to eq(found_items[:data].first[:attributes][:unit_price])
      expect(item1.merchant_id).to eq(found_items[:data].first[:attributes][:merchant_id])

      expect(item2.name).to eq(found_items[:data].last[:attributes][:name])
      expect(item2.description).to eq(found_items[:data].last[:attributes][:description])
      expect(item2.unit_price).to eq(found_items[:data].last[:attributes][:unit_price])
      expect(item2.merchant_id).to eq(found_items[:data].last[:attributes][:merchant_id])
    end
    it "can find all items with the same unit_price" do
      item1 = create(:item, unit_price: 20.00,merchant_id: @merchant.id)
      item2 = create(:item, unit_price: 20.00, merchant_id: @merchant.id)

      get "/api/v1/items/find_all?unit_price=20.00"

      found_items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(found_items).to be_a(Hash)
      expect(found_items[:data]).to be_an(Array)

      expect(item1.name).to eq(found_items[:data].first[:attributes][:name])
      expect(item1.description).to eq(found_items[:data].first[:attributes][:description])
      expect(item1.unit_price).to eq(found_items[:data].first[:attributes][:unit_price])
      expect(item1.merchant_id).to eq(found_items[:data].first[:attributes][:merchant_id])

      expect(item2.name).to eq(found_items[:data].last[:attributes][:name])
      expect(item2.description).to eq(found_items[:data].last[:attributes][:description])
      expect(item2.unit_price).to eq(found_items[:data].last[:attributes][:unit_price])
      expect(item2.merchant_id).to eq(found_items[:data].last[:attributes][:merchant_id])
    end
  end
end
