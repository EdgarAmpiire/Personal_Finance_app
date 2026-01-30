class AddStartingBalanceCentsToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :starting_balance_cents, :integer
  end
end
