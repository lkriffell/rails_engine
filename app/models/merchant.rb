class Merchant < ApplicationRecord
  validates :name, presence: true
  has_many :items, dependent: :destroy
  has_many :invoices
  has_many :customers, through: :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  def self.top_revenue(limit)
    select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) as revenue")
      .joins(invoices: [:invoice_items, :transactions])
      .where(invoices: {status: 'shipped'})
      .where(transactions: {result: 'success'})
      .order('revenue DESC')
      .group('merchants.id')
      .limit(limit)
  end

  def self.most_items_sold(limit)
    select("merchants.*, SUM(invoice_items.quantity) as items_sold")
      .joins(invoices: [:invoice_items, :transactions])
      .where(invoices: {status: 'shipped'})
      .where(transactions: {result: 'success'})
      .order('items_sold DESC')
      .group('merchants.id')
      .limit(limit)
  end

  def self.total_revenue(start, stop)
    select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) as revenue")
      .joins(invoices: [:invoice_items, :transactions])
      .where(invoice_items: {created_at: "BETWEEN '#{start}' AND '#{stop}'"})
      .where(invoices: {status: 'shipped'})
      .where(transactions: {result: 'success'})
      .group('merchants.id')

  end

  def merchant_revenue
    (invoices
    .joins(:transactions)
    .where(invoices: {status: 'shipped'})
    .where(transactions: {result: "success"})
    .joins(:invoice_items)
    .sum("invoice_items.quantity * invoice_items.unit_price")).round(2)
  end

  def items_sold
    (invoices
    .joins(:transactions)
    .where(invoices: {status: 'shipped'})
    .where(transactions: {result: "success"})
    .joins(:invoice_items)
    .sum("invoice_items.quantity"))
  end
end
