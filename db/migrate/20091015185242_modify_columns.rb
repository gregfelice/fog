class ModifyColumns < ActiveRecord::Migration

  def self.up

    drop_table "prov_xns"

    create_table "prov_xns", :force => true do |t|
      
      t.string "username"
      t.string "password"
      t.string "employeenumber"
      t.string "familyname"
      t.string "givenname"
      t.string "suspended"

      t.text "comment"

    end

  end

  def self.down
  end

end
