
require 'provisioner_google'
require 'user_entry'

class CoreController < ApplicationController

  def test
    
    @testvar = "this is a test!!!"
    
    # perform a test, accessing the google stuff. 
    p = Provisioner::ProvisionerGoogle.new
    
    p.init # initializes google ath, atz

    user = p.retrieve_user("btest")
    #puts user.inspect

    logger.debug("user: #{user.inspect}")
    
    @user = user

  end

end
