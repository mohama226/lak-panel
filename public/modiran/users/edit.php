<?php

require "../../../app/auth.php";
checkLogin();

require "../../../app/database.php";
require "../../../app/jalali.php";
require "../../../app/ocserv.php";
require "../../../app/logger.php";   // ← اضافه شد

$id = $_GET['id'];

$stmt = $db->prepare("SELECT * FROM users WHERE id=?");
$stmt->execute([$id]);
$user = $stmt->fetch();

$msg = "";

if($_POST){

    $username = $_POST['username'];
    $expire   = $_POST['expire_date'];
    $total    = $_POST['total_gb'];

    $stmt = $db->prepare("
        UPDATE users SET
        username=?,
        expire_date=?,
        total_gb=?
        WHERE id=?
    ");

    $stmt->execute([
        $username,
        $expire,
        $total,
        $id
    ]);

    // 🔥 ثبت لاگ مدیریت (قدیمی)
    admin_log(
        "ویرایش کاربر",
        $username,
        "ویرایش مشخصات کاربر انجام شد"
    );

    // 🔥 ثبت لاگ مدیریت (نسخه جدید طبق دستور تو)
    admin_log(
        $db,
        "ویرایش اطلاعات کاربر",
        $username
    );

    // 🔥 لاگ فایل admin.log
    writeLog(
        "admin.log",
        "مدیر ".$_SESSION['admin']." کاربر ".$username." را ویرایش کرد"
    );

    // 🔥 لاگ جدید قبل از انتقال صفحه
    if(function_exists('writeLog')){
        writeLog(
            $_SESSION['admin'],
            "ویرایش کاربر VPN: ".$username
        );
    }

    // 🔥 تغییر رمز در ocserv (اگر رمز جدید ارسال شده باشد)
    if(isset($_POST['password']) && trim($_POST['password']) !== ""){
        ocserv_change_password(
            $user['username'],
            $_POST['password']
        );
    }

    $msg = "اطلاعات کاربر بروزرسانی شد";
}

include "../../includes/header.php";
include "../../includes/sidebar.php";

?>

<main class="content">

<div class="card form-card">

<h2>
✏ ویرایش پروفایل کاربر
</h2>

<?php if($msg): ?>
<div class="success">
    <?=$msg?>
</div>
<?php endif; ?>

<form method="post">

<label>نام کاربری</label>
<input class="form-control" name="username" value="<?=$user['username']?>">

<label>تاریخ انقضا</label>
<input class="form-control" type="date" name="expire_date" value="<?=$user['expire_date']?>">

<p>
تاریخ شمسی:
<b><?= jalali_date($user['expire_date']) ?></b>
</p>

<label>حجم مجاز GB</label>
<input class="form-control" name="total_gb" value="<?=$user['total_gb']?>">

<label>رمز جدید (اختیاری)</label>
<input class="form-control" name="password" placeholder="اگر می‌خواهی رمز تغییر کند">

<button class="login-btn">
ذخیره تغییرات
</button>

</form>

</div>

</main>

<?php
include "../../includes/footer.php";
?>
