
require 'provisioner_google'
require 'provisioner_adadmin'
require 'provisioner_iplanet'
require 'object_not_found_exception'

class ProvXn < ActiveRecord::Base
  
  attr :username
  attr :employeenumber
  attr :password
  attr :suspended

  def initialize(employeenumber, username, password)
    @employeenumber = employeenumber
    @username = username
    @password = password
  end

  #
  # staff/faculty will be in ldap AND ad
  # students will be in ldap AND google.
  #
  # get from ldap (pk: employeenumber)
  # dump: https://nyitfu.nyit.edu/userfu/dump_ldap.php?search=gfelice
  #
  def self.find(employeenumber)

    raise ArgumentError, "employeenumber blank", caller if employeenumber.empty? 

    begin
      
      # try iplanet first
      p = Provisioner::ProvisionerIplanet.new
      p.init
      usr = p.retrieve_user(employeenumber)
      
    rescue ObjectNotFoundException
      logger.info("{caller} object not found for emp no: [#{employeenumber}] Exception: #{$!}")
      raise
    rescue
      logger.error("{caller} unexplained error Exception: #{$!}")
      raise # re-raises last exception
    end
    
    return usr
  end

  # override
  def save
    raise NotImplementedError
  end

  # override
  def update_attributes(attributes)
    
    #logger.debug "updateattributes --------------------------------------------------------------------------------------------"
    #logger.debug attributes
    #logger.debug attributes.class
    #logger.debug attributes.inspect
    #logger.debug "end updateattributes ----------------------------------------------------------------------------------------"
    
    raise ArgumentError, "employeenumber blank", caller if attributes['employeenumber'] == nil || attributes['employeenumber'].empty? 
    raise ArgumentError, "password blank", caller if attributes['password'] == nil || attributes['password'].empty? 
    
    begin
      p_iplanet = Provisioner::ProvisionerIplanet.new
      p_iplanet.init
    rescue
      logger.fatal("provisioner init failed for some reason: Exception #{$!}")
      errors.add $!
      exit
    end
    
    # usr 1 --> 1 mailhost
    
    # retrieve usr from iplanet --  if not found, exit/fail
    begin
      usr = p_iplanet.retrieve_user(attributes['employeenumber'])
    rescue Provisioner::ObjectNotFoundException
      logger.error("{caller} object not found for emp no: [#{attributes['employeenumber']}] Exception: #{$!}")
      errors.add $!
      raise
    rescue
      logger.fatal("fail on retireve for update: Exception #{$!}")
      raise
    end
    
    begin
      # if usr.mailhost is mymailg.nyit.edu then update iplanet && google
      if usr.mailhost == "mymailg.nyit.edu"
        
        p_iplanet.update_user_attributes(attributes)

        p_google = Provisioner::ProvisionerGoogle.new
        p_google.init
       
        p_google.update_user_attributes(attributes)
        
      end
      
      # if usr.mailhost is thor.nyit.edu, update iplanet
      if usr.mailhost == "thor.nyit.edu"

        p_iplanet.update_user_attributes(attributes) 

      end

      # if usr.mailhost is owexht.nyit.edu, update iplanet, adadmin
      if usr.mailhost == "owexht.nyit.edu" 
        
        p_iplanet.update_user_attributes(attributes) 

        #p_adadmin = Provisioner::ProvisionerADAdmin.new
        #p_adadmin.init
        
        #p_adadmin.update_user_attributes(attributes)
        
      end
      
      # if usr.mailhost is thor && userclass is (faculty || staff) then update adadmin
      if usr.mailhost == "thor.nyit.edu" && (usr.userclass == "faculty" || usr.userclass == "staff")
        
        #p_adadmin = Provisioner::ProvisionerADAdmin.new
        #p_adadmin.init
        
        #p_adadmin.update_user_attributes(attributes)
        
      end

    rescue
      logger.error("error during update for employee number #{attributes['employeenumber']}: Exception #{$!}")
      errors.add $!
      raise
    end
    
    return true
    
  end

  # override
  def destroy
    raise NotImplementedError
  end
  
end

