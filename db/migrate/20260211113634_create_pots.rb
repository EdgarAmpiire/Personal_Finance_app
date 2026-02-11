class CreatePots < ActiveRecord::Migration[8.0]
  def change
    create_table :pots do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :color, null: false, default: "#14b8a6"
      t.bigint :target_cents, null: false, default: 0
      t.bigint :saved_cents,  null: false, default: 0

      t.timestamps
    end
  end
end
