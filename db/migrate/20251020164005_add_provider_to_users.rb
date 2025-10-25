class AddProviderToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string

    # Add indexes for better performance
    add_index :users, :provider
    add_index :users, :uid
    add_index :users, [ :provider, :uid ], unique: true
  end
end
