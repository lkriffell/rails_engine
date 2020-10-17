class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :invoice
      t.string :cc_num
      t.string :result

      t.timestamps
    end
  end
end
