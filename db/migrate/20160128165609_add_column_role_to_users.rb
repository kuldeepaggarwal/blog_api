class AddColumnRoleToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :role, :integer

    User.reset_column_information
    User.update_all(role: User.roles[:blogger])
  end

  def down
    remove_column :users, :role
  end
end
