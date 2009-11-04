#!/usr/bin/ruby

require 'rest_client'
require "rexml/document"
include REXML

def get_error_string(xml)
  s = ""
  doc = Document.new(xml)
  doc.elements.each("errors/error") { |element| s << "[#{element.text}]" }
  return s
end

employeenumber=ENV['LDAP_EMPLOYEENUMBER']
password=ENV['LDAP_USERPASSWORD']

xml = <<EOF
<prov-xn>
  <employeenumber>#{employeenumber}</employeenumber>
  <password>#{password}</password>
</prov-xn>
EOF

client = RestClient.new('automattest.nyit.edu', 443, {'content-type' => 'application/xml'})
client.basic_auth('gregf', 'password')

resp = client.PUT("/prov_xns/#{employeenumber}.xml", xml)    

if ((resp.body =~ /errors/) == nil)
  puts "[#{Time.now}] password reset success: employeenumber #{employeenumber}"
  exit 0 
else 
  puts "[#{Time.now}] password reset error: employeenumber #{employeenumber}: #{get_error_string(resp.body)}"
  exit 1
end




