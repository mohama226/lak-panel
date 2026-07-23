<?php


session_start();


unset($_SESSION['vpn_user']);


header("Location: /users");


exit;


?>
