class AccountsController < ApplicationController

  # POST /login
  def login

    @testvar = "testvar"
    
    auth = "the test auth key!!!!"

    # get the parameters.. username, password. service.

    #session[:user] = ProvUser.authenticate(user_name, password)

    session[:user] = "this is a test auth key in session"
    
    render :text => auth, :status => 200, :layout => false
    
  end

end
