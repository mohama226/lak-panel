<?php

require "../../../app/auth.php";
checkLogin();

require "../../../app/database.php";
require "../../../app/ocserv.php";
require "../../../app/logger.php";   // ← اضافه شد

$id = $_GET['id'];

$stmt = $db->prepare(
    "SELECT username FROM users WHERE id=?"
);

$stmt->execute([$id]);

$user = $stmt->fetch();

if($user){

    // 🔥 ثبت لاگ قبل از حذف (طبق دستور قبلی)
    admin_log(
        "حذف کاربر",
        $user['username'],
        "کاربر از پنل حذف شد"
    );

    // حذف از ocserv
    ocserv_delete_user(
        $user['username']
    );

    // حذف از دیتابیس
    $stmt = $db->prepare(
        "DELETE FROM users WHERE id=?"
    );
    $stmt->execute([$id]);

    // 🔥 ثبت لاگ بعد از حذف موفق
    admin_log(
        $db,
        "حذف کاربر",
        $user['username']
    );
}

header("Location:/modiran/users");
exit;

?>
