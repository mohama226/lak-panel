<?php

require "../../../app/auth.php";
checkLogin();

require "../../../app/database.php";
require "../../../app/ocserv.php";   // ← اضافه شد

$msg = "";

if($_POST){

    $username = trim($_POST['username']);
    $password = trim($_POST['password']);
    $expire   = $_POST['expire_date'];
    $volume   = $_POST['total_gb'];

    if($username && $password){

        $hash = password_hash($password, PASSWORD_DEFAULT);

        $stmt = $db->prepare("
            INSERT INTO users
            (username,password,expire_date,total_gb)
            VALUES
            (?,?,?,?)
        ");

        $stmt->execute([
            $username,
            $hash,
            $expire,
            $volume
        ]);

        // 🔥 اضافه شد: ساخت کاربر در ocserv
        ocserv_add_user($username, $password);

        $msg = "کاربر با موفقیت ساخته شد";
    }
}

include "../../includes/header.php";
include "../../includes/sidebar.php";

?>

<div class="content">

<div class="form-box">

<h2>➕ افزودن کاربر VPN</h2>

<?php if($msg): ?>
<div class="alert-success">
    <?=$msg?>
</div>
<?php endif; ?>

<form method="post">

<label>نام کاربری</label>
<input 
    class="form-control"
    name="username"
    placeholder="مثلا user100"
    required
>

<label>رمز عبور</label>
<input 
    class="form-control"
    name="password"
    placeholder="رمز عبور"
    required
>

<label>تاریخ انقضا</label>
<input
    class="form-control"
    type="date"
    name="expire_date"
    required
>

<label>حجم مجاز (GB)</label>
<input
    class="form-control"
    name="total_gb"
    placeholder="مثلا 100"
>

<button class="form-btn">
    ساخت کاربر
</button>

</form>

</div>

</div>

<?php
include "../../includes/footer.php";
?>
