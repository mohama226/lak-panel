<?php

function writeLog($file,$message){

$dir = __DIR__ . "/../storage/logs/";

if(!is_dir($dir)){
    mkdir($dir,0777,true);
}


$time = date("Y-m-d H:i:s");


$data = "[".$time."] ".$message."\n";


file_put_contents(
    $dir.$file,
    $data,
    FILE_APPEND
);


}

?>
