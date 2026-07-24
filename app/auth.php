<?php

if(session_status() === PHP_SESSION_NONE){

    session_set_cookie_params([
        'path' => '/',
        'httponly' => true,
        'samesite' => 'Lax'
    ]);

    session_start();

}


function checkLogin(){


    if(!isset($_SESSION['admin'])){


        header("Location: /modiran/index.php");

        exit;


    }


}

?>
