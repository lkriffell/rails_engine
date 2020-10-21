require 'rails_helper'

describe "Merchants API" do
  describe "CRUD" do
    it "sends a list of merchants" do
      create_list(:merchant, 5)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(5)
    end

    it "can get one merchant by its id" do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant[:data][:id]).to eq(id.to_s)
    end

    it "can create a new merchant" do
      merchant_params = { name: "Al's Toy Barn" }
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant_params)
      merchant = Merchant.last

      expect(response).to be_successful
      expect(merchant.name).to eq(merchant_params[:name])
    end

    it "can update an existing merchant" do
      id = create(:merchant).id
      previous_name = Merchant.last.name
      merchant_params = { name: "Al's Toy Barn" }
      headers = {"CONTENT_TYPE" => "application/json"}

      put "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate(merchant_params)
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
  end

  describe 'Relationships' do
    it "can find a merchants items through merchant id" do
      merchant = create(:merchant)
      create(:item, merchant_id: merchant.id)
      create(:item, merchant_id: merchant.id)
      create(:item, merchant_id: merchant.id)
      create(:item, merchant_id: merchant.id)

      expect(Merchant.count).to eq(1)

      get "/api/v1/merchants/#{merchant.id}/items"

      items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(items).to be_a(Hash)
      expect(items[:data]).to be_an(Array)
      expect(items[:data].count).to eq(4)
    end

    it "can find a merchant through its item" do
      merchant = create(:merchant)
      create(:item, merchant_id: merchant.id)
      create(:item, merchant_id: merchant.id)
      create(:item, merchant_id: merchant.id)
      item = create(:item, merchant_id: merchant.id)

      expect(Merchant.count).to eq(1)

      get "/api/v1/items/#{item.id}/merchant"

      items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(items).to be_a(Hash)
      expect(items[:data]).to be_a(Hash)
      expect(items[:data][:relationships][:items][:data].count).to eq(4)
      expect(items[:data][:id]).to eq(merchant.id.to_s)
    end
  end
  describe 'Search Endpoints' do
    it "can find a merchant through querying it's name" do
      merchant = create(:merchant, name: "Al's Toy Barn")

      expect(Merchant.count).to eq(1)

      get "http://localhost:3000/api/v1/merchants/find?name=Al's+Toy+Barn"

      found_merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(found_merchant[:data]).to be_a(Hash)
      expect(merchant.name).to eq(found_merchant[:data][:attributes][:name])
      expect(merchant.id.to_s).to eq(found_merchant[:data][:id])
    end

    it "can find merchants through querying their similar names" do
      merchant1 = create(:merchant, name: "Al's Toy Barn")
      merchant2 = create(:merchant, name: "Al's Koi Barn")

      get "http://localhost:3000/api/v1/merchants/find_all?name=BARN"

      found_merchants = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(found_merchants).to be_a(Hash)
      expect(found_merchants[:data]).to be_an(Array)
      expect(found_merchants[:data].size).to eq(2)
      expect(merchant1.name).to eq(found_merchants[:data].first[:attributes][:name])
      expect(merchant1.id.to_s).to eq(found_merchants[:data].first[:id])
    end
  end

  describe 'business endpoints' do
    before :each do
      customer = create :customer
      @merchant1 = create(:merchant)
      invoice1 = create(:invoice, customer_id: customer.id, merchant_id: @merchant1.id)
      item1 = create(:item, unit_price: 7, merchant_id: @merchant1.id)
      create(:invoice_item, item: item1, invoice: invoice1, quantity: 2, unit_price: 7)
      create(:invoice_item, item: item1, invoice: invoice1, quantity: 10, unit_price: 15)
      create(:transaction, invoice: invoice1)

      @merchant2 = create(:merchant)
      invoice2 = create(:invoice, customer_id: customer.id, merchant_id: @merchant2.id)
      item2 = create(:item, unit_price: 10, merchant_id: @merchant2.id)
      create(:invoice_item, item: item2, invoice: invoice2, quantity: 9, unit_price: 10)
      create(:transaction, invoice: invoice2)

      @merchant3 = create(:merchant)
      invoice3 = create(:invoice, customer_id: customer.id, merchant_id: @merchant3.id)
      item3 = create(:item, unit_price: 10, merchant_id: @merchant3.id)
      create(:invoice_item, item: item3, invoice: invoice3, quantity: 10, unit_price: 10)
      create(:transaction, invoice: invoice3)
    end

    it "can find merchants with the most revenue" do
      get "http://localhost:3000/api/v1/merchants/most_revenue?quantity=2"

      found_merchants = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(found_merchants).to be_a(Hash)
      expect(found_merchants[:data]).to be_an(Array)
      expect(found_merchants[:data].size).to eq(2)
      expect(@merchant1.name).to eq(found_merchants[:data].first[:attributes][:name])
      expect(@merchant1.id.to_s).to eq(found_merchants[:data].first[:id])
      expect(164.0).to eq(found_merchants[:data].first[:attributes][:total_revenue])
      expect(@merchant3.name).to eq(found_merchants[:data].last[:attributes][:name])
      expect(@merchant3.id.to_s).to eq(found_merchants[:data].last[:id])
      expect(100).to eq(found_merchants[:data].last[:attributes][:total_revenue])
    end

    it "can find merchants with the most items sold" do
      get "http://localhost:3000/api/v1/merchants/most_items?quantity=2"

      found_merchants = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(found_merchants[:data]).to be_an(Array)
      expect(found_merchants[:data].size).to eq(2)
      expect(@merchant1.name).to eq(found_merchants[:data].first[:attributes][:name])
      expect(@merchant1.id.to_s).to eq(found_merchants[:data].first[:id])
      expect(12).to eq(found_merchants[:data].first[:attributes][:items_sold])
      expect(@merchant3.name).to eq(found_merchants[:data].last[:attributes][:name])
      expect(@merchant3.id.to_s).to eq(found_merchants[:data].last[:id])
      expect(10).to eq(found_merchants[:data].last[:attributes][:items_sold])
    end

    it "can return all revenue between a date range" do
      get "http://localhost:3000/api/v1/revenue?start=2020-10-18&end=2020-10-20"

      found_merchants = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(found_merchants[:data]).to be_an(Array)
      expect(found_merchants[:data].size).to eq(2)
      expect(@merchant1.name).to eq(found_merchants[:data].first[:attributes][:name])
      expect(@merchant1.id).to eq(found_merchants[:data].first[:id])
      expect(12).to eq(found_merchants[:data].first[:attributes][:items_sold])
      expect(@merchant3.name).to eq(found_merchants[:data].last[:attributes][:name])
      expect(@merchant3.id).to eq(found_merchants[:data].last[:id])
      expect(10).to eq(found_merchants[:data].last[:attributes][:items_sold])
    end
    it "can return total revenue for one merchant" do
      get "http://localhost:3000/api/v1/merchants/#{@merchant1.id}/revenue"

      merchant_revenue = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(merchant_revenue[:data]).to be_a(Hash)
      expect(merchant_revenue[:data][:id]).to eq(@merchant1.id.to_s)
      expect(merchant_revenue[:data][:attributes][:name]).to eq(@merchant1.name)
      expect(merchant_revenue[:data][:attributes][:total_revenue]).to eq(@merchant1.merchant_revenue)
      expect(merchant_revenue[:data][:attributes][:items_sold]).to eq(12)
    end
  end
end
