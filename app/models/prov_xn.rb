
class ProvXn < ActiveRecord::Base

  public 
  
  # override - note -- id is a uid string not a numeric key
  def self.find(id)
    
    logger.debug("provxn.find(): passed uid of #{id}")
    
    # staff/faculty will be in ldap AND ad
    # students will be in ldap AND google.

    # get from ldap (pk: username)
    # https://nyitfu.nyit.edu/userfu/dump_ldap.php?search=gfelice
    # p_ldap = Provisioner::ProvisionerLdap.new
    # usr_ldap = p_ldap.retrieve_user(id)

    # get from AD (pk: username)
    # https://nyitfu.nyit.edu/userfu/dump_ad.php?search=gfelice
    # p_ad = Provisioner::ProvisionerAd.new
    # usr_ad = p_ad.retrieve_user(id)

    # get from google (pk: username)
    p_goog = Provisioner::ProvisionerGoogle.new
    
    logger.debug("#{p_goog.inspect}")

    p_goog.init

    logger.debug("#{p_goog.inspect}")

    usr_goog = p_goog.retrieve_user(id)
    
    # initialize object
    pxn = ProvXn.new

    pxn.userpassword = usr_goog.password
    pxn.uid = usr_goog.username
    pxn.givenname = usr_goog.firstname

    return pxn

  end

  # override
  def save

  end
  
  # override (arg is a key-value hash)
  def update_attributes(rovxn)  
    
    
    

  end
  
  # override
  def destroy

  end

end





=begin

    #pxn.sessionid = "0"
    #pxn.operator = "fog"
    #pxn.dn
    #pxn.employeenumber
    #pxn.userclass





    sessionid # fog
    operator # fog

    common-cn # Greg Felice
    common-givenname # Greg
    common-sn # Felice

    ad-samaccountname # same as uid
    ad-employeeid # ad 
    
    iplanet-uid
    iplanet-dn # your ldap structure as a string
    iplanet-ldapemployeenumber # ldap
    iplanet-userpassword
    iplanet-userclass # iplanet specific

    created_at # fog
    updated_at # fog
=end
