#!/usr/bin/ruby

#ENV['RUBYLIB']=.:./lib:./test

require 'rest_client'

employeenumber=ENV['LDAP_EMPLOYEENUMBER']
password=ENV['LDAP_USERPASSWORD']

# start parameter checking
# end parameter checking

xml = <<EOF
<prov-xn>
  <employeenumber>#{employeenumber}</employeenumber>
  <password>#{password}</password>
</prov-xn>
EOF

client = RestClient.new('automattest.nyit.edu', 443, {'content-type' => 'application/xml'})
client.basic_auth('gregf', 'password')

resp = client.PUT("/prov_xns/#{employeenumber}.xml", xml)    

if ! ((resp.to_s =~ /HTTPOK/) == nil) 
  puts "resetpw.rb - exiting with no errors"
  exit 0 
else 
  puts "resetpw.rb - exiting with errors: #{resp.to_s}"
  exit 1
end

