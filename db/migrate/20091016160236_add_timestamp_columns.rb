class AddTimestampColumns < ActiveRecord::Migration
  def self.up

    add_column :prov_xns, :created_at, :datetime
    add_column :prov_xns, :updated_at, :datetime

  end

  def self.down
  end
end
