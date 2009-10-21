class DropPeopleAndSession < ActiveRecord::Migration
  def self.up

    drop_table :sessions
    drop_table :people

  end

  def self.down
  end
end
