<?php

session_start();


unset($_SESSION['vpn_user']);

unset($_SESSION['vpn_id']);


header("Location: /users");

exit;

?>
