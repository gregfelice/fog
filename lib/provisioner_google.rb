

require 'provisioner_interface'
require 'provisioner_exception'
require 'object_not_found_exception'

require 'util'

require 'rexml/document'

include REXML # so we don't have to preface everything with REXML

require 'rest_client'

=begin

@todo compare xml against google dtds
@todo get header overrides in place for http puts and deletes

google provisioner API docs
http://code.google.com/apis/apps/gdata_provisioning_api_v2.0_reference.html

=end
module Provisioner

  @rest_client = nil

  class ProvisionerGoogle < ProvisionerInterface
    
    public
    
    def init
      
      ath_rest = RestClient.new('www.google.com', 443, {'content-type' => 'application/x-www-form-urlencoded'})

      data = { 'Email' => 'nyitadmin@nyit.edu', 'Passwd' => 'G00gely!', 'accountType' => 'HOSTED_OR_GOOGLE', 'service' => 'apps' }
      
      ath_resp = ath_rest.POST('/accounts/ClientLogin', Util.hash_to_querystring(data))
      
      ath_token = ath_resp.body.chomp.grep(/Auth=/)
      
      atz_header = "GoogleLogin #{ath_token}"
      
      headers = { 'authorization' => atz_header, 'content-type' => 'application/atom+xml' } 
      
      @rest_client = RestClient.new('apps-apis.google.com',443, headers)
      
    end
    
    def retrieve_users_all
      
      resp = @rest_client.GET('/a/feeds/nyit.edu/user/2.0')
      
      feed = Document.new(resp)
      
      #puts feed.elements.to_a("//apps:name")
      
      feed.elements.each('entry') do |entry|
        
        puts 'name: ' + entry.elements['apps:name'].text
        #puts 'type: ' + entry.elements['category'].attribute('label').value
        #puts 'updated: ' + entry.elements['updated'].text
        #puts 'id: ' + entry.elements['id'].text
        
        # Extract the href value from each <atom:link>
        links = {}
        entry.elements.each('link') do |link|
          links[link.attribute('rel').value] = link.attribute('href').value
        end
        
        #puts links.to_s
        
      end
      
    end
    
    def retrieve_user(username)
      
      #logger.debug("retrieve_user: username: #{username}")

      raise ArgumentError, "username blank", caller if username.empty? 

      resp = @rest_client.GET("/a/feeds/nyit.edu/user/2.0/#{username}")
      
      feed = Document.new(resp)
      
      unless ! XPath.match( feed, "/AppsForYourDomainErrors" ).empty?

        xn = ProvXn.new      
        
        xn.givenname = feed.elements["//apps:name"].attributes["givenName"]
        xn.familyname = feed.elements["//apps:name"].attributes["familyName"]
        xn.username = feed.elements["//apps:login"].attributes["userName"]
        
        return xn
        
      end
      
      #puts "errors inspect: #{errors.inspect} size: #{errors.length} type: #{errors.type}"
        
      error_code = feed.elements["//AppsForYourDomainErrors/error"].attributes["errorCode"]
      reason = feed.elements["//AppsForYourDomainErrors/error"].attributes["reason"]
      
      if error_code == '1301'
        raise ObjectNotFoundException.new(error_code, reason), "object not found"
      else 
        raise ProvisionerException.new(error_code, reason), "unhandled error"
      end
      
    end
    
    def create_user(user)
      
      raise ArgumentError, "user nil or username blank", caller if user == nil || user.username.empty? 

      path = "/a/feeds/nyit.edu/user/2.0"
      
      xml = <<EOF
      <?xml version="1.0" encoding="UTF-8"?>

      <atom:entry xmlns:atom="http://www.w3.org/2005/Atom" xmlns:apps="http://schemas.google.com/apps/2006">
        <atom:category scheme="http://schemas.google.com/g/2005#kind" term="http://schemas.google.com/apps/2006#user"/>
        <apps:login userName="#{user.username}" password="#{user.password}" suspended="false"/>
        <apps:name familyName="#{user.lastname}" givenName="#{user.firstname}"/>
        <!-- <apps:quota limit="2048"/> -->
      </atom:entry>
EOF
      
      # puts "XML: #{xml}"
      
      xmldoc = Document.new(xml)
      
      resp = @rest_client.POST(path, xmldoc.to_s)
      
    end
    
    # current implementation only updates password field
    def update_user(provxn)
      
      raise ArgumentError, "malformed user", caller if provxn == nil

      path = "/a/feeds/nyit.edu/user/2.0/#{provxn.username}"
      
      xml = <<EOF
      <?xml version="1.0" encoding="UTF-8"?>

      <atom:entry xmlns:atom="http://www.w3.org/2005/Atom" xmlns:apps="http://schemas.google.com/apps/2006" xmlns:gd="http://schemas.google.com/g/2005">

        <atom:id>https://apps-apis.google.com/a/feeds/nyit.edu/user/2.0/#{provxn.username}</atom:id>

        <apps:login userName="#{provxn.username}" password="#{provxn.password}" suspended="false" admin="false" changePasswordAtNextLogin="false" agreedToTerms="true"/>

      </atom:entry>
EOF
      
      puts "XML: #{xml}"
      
      xmldoc = Document.new(xml)
      
      resp = @rest_client.PUT(path, xmldoc.to_s)
      
    end
    
    def delete_user(user) 
      
      raise ArgumentError, "user nil or username blank", caller if user == nil || user.username.empty? 

      path = "/a/feeds/nyit.edu/user/2.0/#{user.username}"
      
      resp = @rest_client.DELETE(path)
      
    end
    
  end
  
end # module
