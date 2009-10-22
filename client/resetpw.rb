#!/usr/bin/ruby

employeenumber=ENV['LDAP_EMPLOYEENUMBER']
userpassword=ENV['LDAP_USERPASSWORD']

client = RestClient.new('automattest.nyit.edu', 80, {'content-type' => 'application/atom+xml'})

xml = <<EOF    
<prov-xn>
  <comment nil="true"/>
  <created-at nil="true" type="datetime"/>
  <employeenumber>#{employeenumber}</employeenumber>
  <familyname nil="true"/>
  <givenname nil="true"/>
  <password>#{userpassword}</password>
  <suspended nil="true"/>
  <updated-at nil="true" type="datetime"/>
  <username nil="true"/>
</prov-xn>
EOF

resp = client.PUT("/prov_xns/#{employeenumber}.xml", xml)    

puts resp

