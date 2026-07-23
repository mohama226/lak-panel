<?php


if(session_status() === PHP_SESSION_NONE){

session_start();

}



function checkLogin(){


if(!isset($_SESSION['admin'])){


header("Location: /modiran");

exit;


}


}


?>
