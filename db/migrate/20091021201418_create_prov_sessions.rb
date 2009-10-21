class CreateProvSessions < ActiveRecord::Migration
  def self.up
    create_table :prov_sessions do |t|
      t.string :ip
      t.string :path
      t.string :session_key

      t.timestamps
    end
  end

  def self.down
    drop_table :prov_sessions
  end
end
