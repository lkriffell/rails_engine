require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants.count).to eq(5)
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["id"]).to eq(id)
  end

  it "can create a new merchant" do
    merchant_params = { name: "Al's Toy Barn" }
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/merchants", headers: headers, params: JSON.generate({merchant: merchant_params})
    merchant = Merchant.last

    expect(response).to be_successful
    expect(merchant.name).to eq(merchant_params[:name])
  end

  it "can update an existing merchant" do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = { name: "Al's Toy Barn" }
    headers = {"CONTENT_TYPE" => "application/json"}

    put "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate({merchant: merchant_params})
    merchant = Merchant.find(id)

    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq("Al's Toy Barn")
  end

  it "can destroy an merchant" do
    merchant = create(:merchant)

    expect(Merchant.count).to eq(1)

    delete "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful
    expect(Merchant.count).to eq(0)
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "destroy a merchants item when merchant is destroyed" do
    merchant = create(:merchant)
    create(:item, merchant_id: merchant.id)

    expect(Merchant.count).to eq(1)

    delete "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful
    expect(Merchant.count).to eq(0)
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
    expect(Item.count).to eq(0)
  end

  it "can find a merchants items through merchant id" do
    merchant = create(:merchant)
    create(:item, merchant_id: merchant.id)
    create(:item, merchant_id: merchant.id)
    create(:item, merchant_id: merchant.id)
    create(:item, merchant_id: merchant.id)

    expect(Merchant.count).to eq(1)

    get "/api/v1/merchants/#{merchant.id}/items"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items).to be_an(Array)
    expect(items.count).to eq(4)
  end

  it "can find a merchant through querying it's name" do
    merchant = create(:merchant)

    expect(Merchant.count).to eq(1)

    get "http://localhost:3000/api/v1/merchant/find?name=#{merchant.name}"

    found_merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_merchant).to be_a(Hash)
    expect(merchant.name).to eq(found_merchant['name'])
    expect(merchant.id).to eq(found_merchant['id'])
  end

  it "can find a merchant through querying it's name" do
    merchant = create(:merchant, name: 'Als Toy Barn')
    merchant = create(:merchant, name: 'Als Food Barn')

    get "http://localhost:3000/api/v1/merchant/find_all?name=Al"

    found_merchants = JSON.parse(response.body)
    require "pry"; binding.pry
    expect(response).to be_successful
    expect(found_merchant).to be_an(Array)
    expect(merchant.name).to eq(found_merchant['name'])
    expect(merchant.id).to eq(found_merchant['id'])
  end
end
