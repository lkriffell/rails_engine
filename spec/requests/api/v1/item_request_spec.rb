require 'rails_helper'

describe "Items API" do
  before :each do
    @merchant = create :merchant
  end

  it "sends a list of items" do
    create(:item, merchant_id: @merchant.id)
    create(:item, merchant_id: @merchant.id)
    create(:item, merchant_id: @merchant.id)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items.count).to eq(3)
  end

  it "can get one item by its id" do
    id = create(:item, merchant_id: @merchant.id).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["id"]).to eq(id)
  end

  it "can create a new item" do
    item_params = { name: 'Corvette', description: 'A car', unit_price: 47, merchant_id: @merchant.id }
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate({item: item_params})
    item = Item.last

    expect(response).to be_successful
    expect(item.name).to eq(item_params[:name])
    expect(item.description).to eq(item_params[:description])
    expect(item.unit_price).to eq(item_params[:unit_price])
    expect(item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "can update an existing item" do
    id = create(:item, merchant_id: @merchant.id).id
    previous_name = Item.last.name
    item_params = { name: "Corvette", unit_price: 134, merchant_id: @merchant.id }
    headers = {"CONTENT_TYPE" => "application/json"}

    put "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
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

  it "merchant can be found through item id" do
    item = create(:item, merchant_id: @merchant.id)

    expect(Item.count).to eq(1)

    get "/api/v1/items/#{item.id}/merchant"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant).to be_a(Hash)
    expect(merchant['name']).to eq(@merchant.name)
    expect(merchant['id']).to eq(@merchant.id)
  end

  it "can find an item through querying it's name" do
    item = create(:item, merchant_id: @merchant.id)

    get "http://localhost:3000/api/v1/item/find?name=#{item.name}"

    found_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_item).to be_a(Hash)
    expect(item.name).to eq(found_item['name'])
    expect(item.description).to eq(found_item['description'])
    expect(item.unit_price).to eq(found_item['unit_price'])
    expect(item.merchant_id).to eq(found_item['merchant_id'])
  end

  it "can find an item through querying it's unit price" do
    item = create(:item, merchant_id: @merchant.id)

    get "http://localhost:3000/api/v1/item/find?unit_price=#{item.unit_price}"

    found_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_item).to be_a(Hash)
    expect(item.name).to eq(found_item['name'])
    expect(item.description).to eq(found_item['description'])
    expect(item.unit_price).to eq(found_item['unit_price'])
    expect(item.merchant_id).to eq(found_item['merchant_id'])
  end
end
