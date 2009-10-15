
require 'net/http'
require 'net/https'
require 'uri'

require 'provisioner_interface'
require 'user_entry'
require 'provisioner_exception'
require 'object_not_found_exception'

require 'util'

require 'rexml/document'

include REXML # so we don't have to preface everything with REXML

=begin

@todo compare xml against google dtds
@todo get header overrides in place for http puts and deletes

=end
module Provisioner

  class ProvisionerGoogle < ProvisionerInterface
    
    @http = nil
    @headers = nil
    
    public
    
    def init
      
      http = Net::HTTP.new('www.google.com', 443)
      
      http.use_ssl = true
      
      path = '/accounts/ClientLogin'
      
      headers = {'content-type' => 'application/x-www-form-urlencoded'}
      
      data = { 'Email' => 'nyitadmin@nyit.edu', 'Passwd' => 'G00gely!', 'accountType' => 'HOSTED_OR_GOOGLE', 'service' => 'apps' }
      
      resp = http.post(path, Util.hash_to_querystring(data), headers)
      
      ath_token = resp.body.chomp.grep(/Auth=/)
      
      atz_header = "GoogleLogin #{ath_token}"
      
      @headers = { 'authorization' => atz_header, 'content-type' => 'application/atom+xml' } 
      
      @http = Net::HTTP.new('apps-apis.google.com', 443)
      
      @http.use_ssl = true
      
    end
    
    def retrieve_users_all
      
      resp = GET('/a/feeds/nyit.edu/user/2.0')
      
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
      
      logger.debug("retrieve_user: username: #{username}")

      raise ArgumentError, "username blank", caller if username.empty? 

      resp = GET("/a/feeds/nyit.edu/user/2.0/#{username}")
      
      feed = Document.new(resp)
      
      unless ! XPath.match( feed, "/AppsForYourDomainErrors" ).empty?

        user = UserEntry.new      
        
        user.firstname = feed.elements["//apps:name"].attributes["givenName"]
        user.lastname = feed.elements["//apps:name"].attributes["familyName"]
        user.username = feed.elements["//apps:login"].attributes["userName"]
        
        return user
        
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
      
      resp = POST(path, xmldoc.to_s)
      
    end
    
    def update_user(olduser, newuser)
      
      raise ArgumentError, "malformed user", caller if olduser == nil || newuser == nil

      path = "/a/feeds/nyit.edu/user/2.0/#{olduser.username}"
      
      xml = <<EOF
      <?xml version="1.0" encoding="UTF-8"?>
        <atom:entry xmlns:atom="http://www.w3.org/2005/Atom" xmlns:apps="http://schemas.google.com/apps/2006" xmlns:gd="http://schemas.google.com/g/2005">
        <atom:id>https://apps-apis.google.com/a/feeds/example.com/user/2.0/#{olduser.username}</atom:id>
        <atom:updated>1970-01-01T00:00:00.000Z</atom:updated>
        <atom:category scheme="http://schemas.google.com/g/2005#kind" term="http://schemas.google.com/apps/2006#user"/>
        <atom:title type="text">#{olduser.username}</atom:title>
        <atom:link rel="self" type="application/atom+xml" href="https://apps-apis.google.com/a/feeds/example.com/user/2.0/#{olduser.username}"/>
        <atom:link rel="edit" type="application/atom+xml" href="https://apps-apis.google.com/a/feeds/example.com/user/2.0/#{olduser.username}"/>
        <apps:login userName="#{newuser.username}" suspended="false" admin="false" changePasswordAtNextLogin="false" agreedToTerms="true"/>
        <apps:name familyName="#{newuser.lastname}" givenName="#{newuser.firstname}"/>
        <gd:feedLink rel="http://schemas.google.com/apps/2006#user.nicknames" href="https://apps-apis.google.com/a/feeds/example.com/nickname/2.0?username=Susy-1321"/>
        <gd:feedLink rel="http://schemas.google.com/apps/2006#user.groups" href="https://apps-apis.google.com/a/feeds//group/2.0/?recipient=us-sales@example.com"/>
      </atom:entry>
EOF
      
      # puts "XML: #{xml}"
      
      xmldoc = Document.new(xml)
      
      resp = PUT(path, xmldoc.to_s)
      
    end
    
    def delete_user(user) 
      
      raise ArgumentError, "user nil or username blank", caller if user == nil || user.username.empty? 

      path = "/a/feeds/nyit.edu/user/2.0/#{user.username}"
      
      resp = DELETE(path)
      
    end
    

    private
    
    def GET(path)
      
      resp = @http.get(path, @headers).body
      
      logger.debug("GET resp: #{resp}\n\n")
      
      return resp
      
    end
    
    def POST(path, xmldoc)
      
      resp = @http.post(path, xmldoc, @headers)
      
      #puts "POST resp: #{resp} #{resp.body}\n\n"
      
      return resp
      
    end
    
    def PUT(path, xmldoc)
      
      resp = @http.put(path, xmldoc, @headers)
      
      #puts "PUT resp: #{resp} #{resp.body}\n\n"
      
      return resp
      
    end
    
    def DELETE(path)
      
      resp = @http.delete(path, @headers)
      
      #puts "DELETE resp: #{resp} #{resp.body}\n\n"
      
      return resp
      
    end
    
  end
  
end # module
