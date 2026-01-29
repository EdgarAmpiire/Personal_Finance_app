class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :description
      t.integer :amount_cents
      t.date :occurred_on

      t.timestamps
    end
  end
end
