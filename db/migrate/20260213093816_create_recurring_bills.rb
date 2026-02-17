class CreateRecurringBills < ActiveRecord::Migration[8.0]
  def change
    create_table :recurring_bills do |t|
      t.references :user, null: false, foreign_key: true

      t.string :title, null: false
      t.integer :amount_cents, null: false, default: 0
      t.integer :due_day, null: false
      t.boolean :active, null: false, default: true
      t.date :last_paid_on

      t.timestamps
    end

    add_index :recurring_bills, :title
    add_index :recurring_bills, :due_day
  end
end
