<?php


function ocserv_add_user($username,$password)
{

$cmd="echo '$password' | ocpasswd -c /etc/ocserv/ocpasswd $username";

exec($cmd,$output,$result);


return $result===0;

}



function ocserv_delete_user($username)
{

$cmd="ocpasswd -c /etc/ocserv/ocpasswd -d $username";


exec($cmd,$output,$result);


return $result===0;

}



function ocserv_restart()
{

exec("systemctl restart ocserv");

}



?>
