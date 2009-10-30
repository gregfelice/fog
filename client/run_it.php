<?php

echo date('Y-m-d H:i:s',time()) . " ----------------------------- BEGINNING RUN -----------------------------\n";

// Reset the Password
PutEnv("LDAP_EMPLOYEENUMBER=0011");
PutEnv("LDAP_USERPASSWORD=kv");

@system("ruby -I ../lib ./resetpw.rb", $yesorno) or die(date('Y-m-d H:i:s',time()) . " Output: " . $yesorno . "\n");

echo date('Y-m-d H:i:s',time()) . " Output: " . $yesorno . "\n";

?>