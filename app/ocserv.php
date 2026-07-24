<?php


function ocserv_add_user($username,$password)
{

$cmd =
"sudo /var/www/html/l-panel/scripts/ocserv-manager.sh add "
.escapeshellarg($username)." "
.escapeshellarg($password);


exec($cmd,$out,$code);


return $code===0;

}



function ocserv_delete_user($username)
{


$cmd =
"sudo /var/www/html/l-panel/scripts/ocserv-manager.sh delete "
.escapeshellarg($username);



exec($cmd,$out,$code);


return $code===0;


}



function ocserv_change_password($username,$password)
{


$cmd =
"sudo /var/www/html/l-panel/scripts/ocserv-manager.sh password "
.escapeshellarg($username)." "
.escapeshellarg($password);



exec($cmd,$out,$code);


return $code===0;


}
