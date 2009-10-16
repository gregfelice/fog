
require 'provisioner_google'

class ProvXn < ActiveRecord::Base

  #
  # pk is empno
  #
  def self.find(id)
    
    logger.debug("ProvXn.find(): passed uid of #{id}")
    
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
    p_goog = get_google_provisioner

    return p_goog.retrieve_user(id)

  end

  # override
  def save
    raise NotImplementedError
  end

  # override of activerecord implementation.
  #
  # save password change to all three provisioning systems.
  #
  def update

    p_goog = ProvXn.get_google_provisioner
    
    logger.debug("p_goog: #{p_goog.inspect}")

    p_goog.update_user(self)

  end
  
  # override
  def destroy
    raise NotImplementedError
  end


  private 

  def self.get_google_provisioner
    p_goog = Provisioner::ProvisionerGoogle.new
    p_goog.init
    return p_goog
  end
  
end

