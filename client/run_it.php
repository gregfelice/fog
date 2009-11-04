<?php

echo date('Y-m-d H:i:s',time()) . " ----------------------------- BEGINNING RUN -----------------------------\n";

// Reset the Password

PutEnv("LDAP_USERPASSWORD=kv3tch8");

PutEnv("LDAP_EMPLOYEENUMBER=0011");
@system("ruby -I ../lib ./resetpw.rb >> ./resetpw.log 2>&1", $yesorno) or die(date('Y-m-d H:i:s',time()) . " Output: " . $yesorno . "\n");
echo date('Y-m-d H:i:s',time()) . " Output: " . $yesorno . "\n";

/*
PutEnv("LDAP_EMPLOYEENUMBER=0012");
@system("ruby -I ../lib ./resetpw.rb >> ./resetpw.log 2>&1", $yesorno) or die(date('Y-m-d H:i:s',time()) . " Output: " . $yesorno . "\n");
echo date('Y-m-d H:i:s',time()) . " Output: " . $yesorno . "\n";

PutEnv("LDAP_EMPLOYEENUMBER=0013");
@system("ruby -I ../lib ./resetpw.rb >> ./resetpw.log 2>&1", $yesorno) or die(date('Y-m-d H:i:s',time()) . " Output: " . $yesorno . "\n");
echo date('Y-m-d H:i:s',time()) . " Output: " . $yesorno . "\n";

//PutEnv("LDAP_USERPASSWORD=kv3tch8");

PutEnv("LDAP_EMPLOYEENUMBER=0014");
@system("ruby -I ../lib ./resetpw.rb >> ./resetpw.log 2>&1", $yesorno) or die(date('Y-m-d H:i:s',time()) . " Output: " . $yesorno . "\n");
echo date('Y-m-d H:i:s',time()) . " Output: " . $yesorno . "\n";

PutEnv("LDAP_EMPLOYEENUMBER=0015");
@system("ruby -I ../lib ./resetpw.rb >> ./resetpw.log 2>&1", $yesorno) or die(date('Y-m-d H:i:s',time()) . " Output: " . $yesorno . "\n");
echo date('Y-m-d H:i:s',time()) . " Output: " . $yesorno . "\n";
*/

?>