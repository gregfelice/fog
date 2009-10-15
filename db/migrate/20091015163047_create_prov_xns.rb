class CreateProvXns < ActiveRecord::Migration
  def self.up
    create_table :prov_xns do |t|

      t.string :sessionid
      t.string :operator
      t.string :uid
      t.string :dn
      t.string :employeenumber
      t.string :userpassword
      t.string :userclass
      t.string :givenname

      t.timestamps
    end
  end

  def self.down
    drop_table :prov_xns
  end
end
