
require 'net/http'
require 'net/https'
require 'uri'

########################################################################################################
=begin

RESTful client support. has been tested with the following mime-types:
application/x-www-form-urlencoded              (basic http post, get)
application/atom+xml                           (google gdata api conversations via http)
application/atom+xml                           (ruby on rails controller conversations via http)

@todo

add support for authentication.. not sure if i need to do anything outside include the auth headers...

yeah, with inititalization accepting headers, could just pass that in.

=end
#######################################################################################################
class RestClient

  attr :headers
  attr :hostname
  attr :port
  attr :http

  def initialize(hostname, port, headers)
    
    @hostname = hostname
    @port = port
    @headers = headers

    @http = Net::HTTP.new(hostname, port)
    
    if port == 443
      http.use_ssl = true
    end

  end
  
  def basic_auth(username, password)

    headers.merge!( { 'authorization' => Base64.encode64("#{username}:#{password}") } )

  end

  # chopped up method to support basic auth
  def GET(path)

    resp = @http.get(path, @headers)

    #puts "GET resp: #{resp}\n\n"
    
    #resp.each_header { |x| puts x }
    
    return resp.body
    
  end
  
  # data can be xml or otherwise
  #
  def POST(path, data)
    
    resp = @http.post(path, data, @headers)
    
    #puts "POST resp: #{resp} #{resp.body}\n\n"
    
    return resp
    
  end
  
  def PUT(path, data)
    
    # puts "-------------------------\nPUT: data: #{data} -- #{@headers}"

    resp = @http.put(path, data, @headers)
    
    #puts "PUT resp: [#{resp}] [#{resp.body}]\n----------------------\n\n"
    
    return resp
    
  end
  
  def DELETE(path)
    
    resp = @http.delete(path, @headers)
    
    #puts "DELETE resp: #{resp} #{resp.body}\n\n"
    
    return resp
    
  end

end
