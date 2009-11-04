require 'provisioner_google'
require 'provisioner_adadmin'
require 'provisioner_iplanet'

class ProvXn < ActiveRecord::Base
  
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
      iplanet_usr = p.retrieve_user(employeenumber)
      begin
        # try adadmin second. may or may not be found.
        p = Provisioner::ProvisionerADAdmin.new
        p.init
        ad_usr = p.retrieve_user(employeenumber)
        iplanet_usr.adadmindn = ad_usr.adadmindn
      rescue ActiveRecord::RecordNotFound
        return iplanet_usr # this is ok. no records found in AD, just return iplanet user.
      end
    rescue ActiveRecord::RecordNotFound
      logger.info("{caller} object not found for emp no: [#{employeenumber}] Exception: #{$!}")
      raise
    rescue
      logger.error("{caller} unexplained error Exception: #{$!}")
      raise # re-raises last exception
    end
    return iplanet_usr
  end
  
  # override
  def save
    raise NotImplementedError
  end
  
  # override
  def update_attributes(attributes)
    #logger.debug("update attributes for: [#{attributes.inspect}]")
    raise ArgumentError, "employeenumber blank", caller if attributes['employeenumber'] == nil || attributes['employeenumber'].empty? 
    validate(attributes)
    if errors.length > 0
      return false
    end
    begin
      p_iplanet = Provisioner::ProvisionerIplanet.new
      p_iplanet.init
      p_google = Provisioner::ProvisionerGoogle.new
      p_google.init
      p_adadmin = Provisioner::ProvisionerADAdmin.new
      p_adadmin.init
    rescue
      logger.fatal("provisioner init failed for some reason: Exception #{$!}. Exiting system.")
      errors.add $!
      exit
    end
    begin
      # if retireve user from iplanet is true (is always), update iplanet info
      begin
        usr = p_iplanet.retrieve_user(attributes['employeenumber'])
        raise RuntimeError, "usr.username nil or empty", caller if usr.username == nil || usr.username.empty?
        raise RuntimeError, "usr.employeenumber nil or empty", caller if usr.employeenumber == nil || usr.employeenumber.empty?
        logger.debug("usr found in iplanet for [#{usr.employeenumber}], updating record...")
        p_iplanet.update_user_attributes(attributes)
        logger.debug("usr found in iplanet for [#{usr.employeenumber}], updated.")
      rescue ActiveRecord::RecordNotFound
        logger.error("object not found for emp no: [#{attributes['employeenumber']}] Exception: #{$!}")
        errors.add $!
        return false
      end
      # if retireve user from google is true, update google info
      begin
        p_google.retrieve_user(usr.username)
        attributes.merge!( { 'username' => usr.username } ) # add the retrived username to the attributes
        logger.debug("usr found in google for [#{usr.username}], updating record...")
        p_google.update_user_attributes(attributes)
        logger.debug("usr found in google for [#{usr.username}], updated.")
      rescue ActiveRecord::RecordNotFound
        logger.debug("usr not found in google for [#{usr.username}]")
        # do nothing...
      end
      # if retireve user from adadmin is true, update adadmin info
      begin
        p_adadmin.retrieve_user(attributes['employeenumber'])
        logger.debug("usr found in adadmin for [#{usr.employeenumber}], updating record...")
        p_adadmin.update_user_attributes(attributes)
        logger.debug("usr found in adadmin for [#{usr.employeenumber}], updated.")
      rescue ActiveRecord::RecordNotFound
        logger.debug("usr not found in adadmin for [#{usr.employeenumber}]")
        # do nothing...
      end
    rescue
      logger.error("error during update for employee number #{attributes['employeenumber']}: Exception #{$!}")
      errors.add $!
      return false
    end
    return true
  end

  # override
  def destroy
    raise NotImplementedError
  end
  
  protected
  
  def validate(attributes)

    password = attributes['password']
    
    # password nil check
    if (password == nil)
      errors.add("password", "Password is nil.")  
      return # no use validating a nil password. return.
    end

    # * Password cannot contain spaces.
    # errors.add("password", "cannot contain spaces or tabs.") unless password.grep(/(.*[\s])/).length == 0

    # * Each password must contain at least two alphabetic characters (all uppercase and lowercase letters) and at least two numeric or special character.
    errors.add("password", "must contain at least two numeric characters.") unless password.grep(/(.*\d){2,}/).length > 0

    # at least 2 letters
    errors.add("password", "must contain at least 2 letters") unless password.grep(/(.*[A-Za-z]){2,}/).length > 0

    # * Password should be minimum six characters long and a maximum of eight characters.
    errors.add("password", "must be between 6 and 8 chars.") unless (password.length >= 6 && password.length <= 8)

    # * Only the following special characters are allowed  !,./+=-_~#$^ 
    i = (password =~ /[^a-zA-Z0-9\/\^\$\!\,\.\+\=\-\_\~\#]/)
    if i != nil
      errors.add("password", "invalid char or spaces in #{password}: \"#{password[i,1]}\"")
    end

  end
  
end


