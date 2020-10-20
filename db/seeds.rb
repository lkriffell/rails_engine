# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'
InvoiceItem.destroy_all
Transaction.destroy_all
Item.destroy_all
Invoice.destroy_all
Merchant.destroy_all
Customer.destroy_all

CSV.foreach(Rails.root.join('lib/seed_csv/customers.csv'), headers: true) do |row|
  Customer.create( {
    id: row["id"],
    first_name: row["first_name"],
    last_name: row["last_name"],
    created_at: row["created_at"],
    updated_at: row["updated_at"]
  } )
end

CSV.foreach(Rails.root.join('lib/seed_csv/merchants.csv'), headers: true) do |row|
  Merchant.create( {
    id: row["id"],
    name: row["name"],
    created_at: row["created_at"],
    updated_at: row["updated_at"]
  } )
end

CSV.foreach(Rails.root.join('lib/seed_csv/invoices.csv'), headers: true) do |row|
  Invoice.create( {
    id: row["id"],
    customer_id: row["customer_id"],
    merchant_id: row["merchant_id"],
    status: row["status"],
    created_at: row["created_at"],
    updated_at: row["updated_at"]
  } )
end

CSV.foreach(Rails.root.join('lib/seed_csv/items.csv'), headers: true) do |row|
  Item.create( {
    id: row["id"],
    name: row["name"],
    description: row["description"],
    unit_price: row["unit_price"],
    merchant_id: row["merchant_id"],
    created_at: row["created_at"],
    updated_at: row["updated_at"]
  } )
end

CSV.foreach(Rails.root.join('lib/seed_csv/transactions.csv'), headers: true) do |row|
  Transaction.create( {
    id: row["id"],
    invoice_id: row["invoice_id"],
    cc_num: row["credit_card_number"],
    result: row["result"],
    created_at: row["created_at"],
    updated_at: row["updated_at"]
  } )
end

CSV.foreach(Rails.root.join('lib/seed_csv/invoice_items.csv'), headers: true) do |row|
  InvoiceItem.create( {
    id: row["id"],
    item_id: row["item_id"],
    invoice_id: row["invoice_id"],
    quantity: row["quantity"],
    unit_price: (row["unit_price"].to_f * 0.01).round(2),
    created_at: row["created_at"],
    updated_at: row["updated_at"]
  } )
end

ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end
