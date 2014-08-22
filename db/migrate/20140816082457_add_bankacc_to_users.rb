class AddBankaccToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bankaccname, :string
  end
end
