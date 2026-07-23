<?php


$db = new PDO(

"mysql:host=localhost;dbname=lpanel;charset=utf8mb4",

"lpanel",

"lpanel123"

);



$db->setAttribute(

PDO::ATTR_ERRMODE,

PDO::ERRMODE_EXCEPTION

);


?>
