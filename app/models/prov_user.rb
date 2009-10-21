class ProvUser < ActiveRecord::Base
  
  has_many :prov_sessions 

  #, :dependent => :destroy
  
end
