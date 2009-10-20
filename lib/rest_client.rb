
require 'net/http'
require 'net/https'
require 'uri'

#
#
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


  def GET(path)
    
    resp = @http.get(path, @headers).body
    
    #logger.debug("GET resp: #{resp}\n\n")
    
    return resp
    
  end
  
  # data can be xml or otherwise
  #
  def POST(path, data)
    
    resp = @http.post(path, data, @headers)
    
    #puts "POST resp: #{resp} #{resp.body}\n\n"
    
    return resp
    
  end
  
  def PUT(path, data)
    
    resp = @http.put(path, data, @headers)
    
    # puts "PUT resp: #{resp} #{resp.body}\n\n"
    
    return resp
    
  end
  
  def DELETE(path)
    
    resp = @http.delete(path, @headers)
    
    #puts "DELETE resp: #{resp} #{resp.body}\n\n"
    
    return resp
    
  end

end
