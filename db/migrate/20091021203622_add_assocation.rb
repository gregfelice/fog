class AddAssocation < ActiveRecord::Migration
  def self.up
    
    drop_table "prov_sessions"
    
    create_table "prov_sessions", :force => true do |t|
      t.belongs_to :prov_user
      t.string   "ip"
      t.string   "path"
      t.string   "session_key"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

  end

  def self.down
  end
end
