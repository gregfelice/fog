class Addcolumnsdnrelated < ActiveRecord::Migration
  def self.up

    add_column :prov_xns, :iplanetdn, :string
    add_column :prov_xns, :adadmindn, :string

  end

  def self.down
  end
end
