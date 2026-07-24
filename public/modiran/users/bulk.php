<?php

require "../../../app/auth.php";
checkLogin();

require "../../../app/database.php";
require "../../../app/ocserv.php";   // ← اضافه شد

$msg = "";

if($_POST){

    $prefix = trim($_POST['prefix']);
    $count  = intval($_POST['count']);
    $expire = $_POST['expire_date'];
    $volume = $_POST['total_gb'];

    if($prefix && $count > 0){

        for($i = 1; $i <= $count; $i++){

            $username = $prefix . str_pad($i, 3, "0", STR_PAD_LEFT);

            $password = substr(
                bin2hex(random_bytes(5)),
                0,
                8
            );

            $hash = password_hash(
                $password,
                PASSWORD_DEFAULT
            );

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
        }

        $msg = $count . " کاربر با موفقیت ساخته شد";
    }
}

include "../../includes/header.php";
include "../../includes/sidebar.php";

?>

<div class="content">

<div class="form-box">

<h2>👥 افزودن گروهی کاربران VPN</h2>

<?php if($msg): ?>
<div class="alert-success">
    <?=$msg?>
</div>
<?php endif; ?>

<form method="post">

<label>پیشوند نام کاربران</label>
<input
    class="form-control"
    name="prefix"
    placeholder="مثلا user"
    required
>

<label>تعداد کاربران</label>
<input
    class="form-control"
    type="number"
    name="count"
    placeholder="مثلا 100"
    required
>

<label>تاریخ انقضا</label>
<input
    class="form-control"
    type="date"
    name="expire_date"
    required
>

<label>حجم هر کاربر (GB)</label>
<input
    class="form-control"
    name="total_gb"
    placeholder="مثلا 50"
>

<button class="form-btn">
    ساخت کاربران
</button>

</form>

</div>

</div>

<?php
include "../../includes/footer.php";
?>
