class AddColumnAuthenticationTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :authentication_token, :string

    add_index :users, :authentication_token, unique: true, name: 'unique_users_on_authentication_token'
  end
end
