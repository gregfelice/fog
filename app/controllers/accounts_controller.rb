
require 'cgi'
require 'cgi/session'


class AccountsController < ApplicationController

  # POST /login
  def login

    @testvar = "testvar"
    
    auth = "the test auth key!!!!"

    # session[:user] = ProvUser.authenticate(username, password)
    
    

    session[:user] = "this is a test auth key in session"

    logger.debug "session info"
    logger.debug CGI::Session::Session.find_by_session_id(@session_id).data[:user]

    render :text => auth, :status => 200, :layout => false

  end

end
