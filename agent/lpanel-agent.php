#!/usr/bin/php
<?php


$socket="/var/run/lpanel-agent.sock";


if(file_exists($socket)){

unlink($socket);

}



$server=stream_socket_server(

"unix://".$socket,

$errno,

$errstr

);



if(!$server){

exit;

}



chmod($socket,0666);



while(true){


$conn=stream_socket_accept($server);



if(!$conn){

continue;

}



$data=fread($conn,4096);



$request=json_decode($data,true);



$response=[
"status"=>"error"
];



if($request['action']=="add"){



$username=$request['username'];

$password=$request['password'];



exec(

"echo '$password' | ocpasswd -c /etc/ocserv/ocpasswd $username",

$out,

$status

);



$response['status']=$status==0?"ok":"error";



}




if($request['action']=="delete"){



$username=$request['username'];



exec(

"ocpasswd -c /etc/ocserv/ocpasswd -d $username",

$out,

$status

);



$response['status']=$status==0?"ok":"error";


}



if($request['action']=="password"){



$username=$request['username'];

$password=$request['password'];



exec(

"echo '$password' | ocpasswd -c /etc/ocserv/ocpasswd $username",

$out,

$status

);



$response['status']=$status==0?"ok":"error";


}




fwrite(

$conn,

json_encode($response)

);



fclose($conn);



}

?>
