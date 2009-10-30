
class ProvXnsController < ApplicationController

  before_filter :authenticate

  # GET /prov_xns
  # GET /prov_xns.xml
  def index
    @prov_xns = ProvXn.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @prov_xns }
    end
  end

  # GET /prov_xns/1
  # GET /prov_xns/1.xml
  def show

    logger.debug("inside show")

    begin
      @prov_xn = ProvXn.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @prov_xn }
      end
    rescue (ActiveRecord::RecordNotFound)
      respond_to do |format|
        logger.error($!)
        format.html
        format.xml  { head :not_found }
      end
    rescue
      
    end
  end
  
  # GET /prov_xns/new
  # GET /prov_xns/new.xml
  def new
    @prov_xn = ProvXn.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @prov_xn }
    end
  end

  # GET /prov_xns/1/edit
  def edit
    @prov_xn = ProvXn.find(params[:id])
  end

  # POST /prov_xns
  # POST /prov_xns.xml
  def create
    @prov_xn = ProvXn.new(params[:prov_xn])

    respond_to do |format|
      if @prov_xn.save
        flash[:notice] = 'ProvXn was successfully created.'
        format.html { redirect_to(@prov_xn) }
        format.xml  { render :xml => @prov_xn, :status => :created, :location => @prov_xn }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @prov_xn.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /prov_xns/1
  # PUT /prov_xns/1.xml
  def update
    @prov_xn = ProvXn.find(params[:id])
    
    logger.debug "PROVXN: #{@prov_xn.inspect}"
    logger.debug "PARAMS: #{params[:prov_xn]}"
    logger.debug "ID: #{params[:id]}"

    respond_to do |format|
      #begin
        #if @prov_xn.update
        if @prov_xn.update_attributes(params[:prov_xn])
          flash[:notice] = 'ProvXn was successfully updated.'
          format.html { redirect_to(@prov_xn) }
          format.xml  { head :ok }
        else
          logger.error($!)
          format.html { render :action => "edit" }
          format.xml  { render :xml => @prov_xn.errors, :status => :unprocessable_entity }
        end
      #rescue 
      #  logger.error($!)
      #  format.html { render :action => "edit" }
      #  format.xml  { render :xml => @prov_xn.errors, :status => :unprocessable_entity }
      #end
    end
  end

  # DELETE /prov_xns/1
  # DELETE /prov_xns/1.xml
  def destroy
    @prov_xn = ProvXn.find(params[:id])
    @prov_xn.destroy

    respond_to do |format|
      format.html { redirect_to(prov_xns_url) }
      format.xml  { head :ok }
    end
  end

  protected
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      _authenticate(username, password, request.remote_ip)
    end
  end

  def _authenticate(username, password, ip) 
    
    if APP_CONFIG['perform-authentication']
      return username == APP_CONFIG['username'] && password == APP_CONFIG['password'] && APP_CONFIG['allowed-hosts'] =~ /#{ip}/
    else
      return true
    end

  end

end
