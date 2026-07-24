<?php

require "../../../app/auth.php";
checkLogin();

require "../../../app/database.php";
require "../../../app/ocserv.php";

$id = $_GET['id'];

$stmt = $db->prepare(
    "SELECT username FROM users WHERE id=?"
);

$stmt->execute([$id]);

$user = $stmt->fetch();

if($user){

    // 🔥 تغییر داده شد
    ocserv_delete_user(
        $user['username']
    );

    $stmt = $db->prepare(
        "DELETE FROM users WHERE id=?"
    );

    $stmt->execute([$id]);
}

header("Location:/modiran/users");
exit;

?>
