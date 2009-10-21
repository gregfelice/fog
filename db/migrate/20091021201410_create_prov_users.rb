class CreateProvUsers < ActiveRecord::Migration
  def self.up
    create_table :prov_users do |t|
      t.string :username
      t.string :password

      t.timestamps
    end
  end

  def self.down
    drop_table :prov_users
  end
end
