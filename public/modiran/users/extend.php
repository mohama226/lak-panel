<?php

require "../../../app/auth.php";
checkLogin();

require "../../../app/database.php";
require "../../../app/jalali.php";   // ← اضافه شد

$id = $_GET['id'];

$stmt = $db->prepare("SELECT * FROM users WHERE id=?");
$stmt->execute([$id]);
$user = $stmt->fetch();

if(!$user){
    die("User Not Found");
}

$msg = "";

if($_POST){

    $days = intval($_POST['days']);
    $current = $user['expire_date'];

    $new_date = date(
        "Y-m-d",
        strtotime($current . " " . $days . " days")
    );

    $stmt = $db->prepare("
        UPDATE users
        SET expire_date=?
        WHERE id=?
    ");

    $stmt->execute([
        $new_date,
        $id
    ]);

    $msg = "اعتبار کاربر تغییر کرد";

    $user['expire_date'] = $new_date;
}

include "../../includes/header.php";
include "../../includes/sidebar.php";

?>

<div class="content">

<div class="form-box">

<h2>
⏱ تغییر اعتبار کاربر
</h2>

<div class="user-info">

<p>
نام کاربر:
<b>
<?=$user['username']?>
</b>
</p>

<!-- 🔥 بخش جدید: تاریخ میلادی + تاریخ شمسی -->
<p>
تاریخ میلادی:
<b>
<?=$user['expire_date']?>
</b>
</p>

<p>
تاریخ شمسی:
<b>
<?= jalali_date($user['expire_date']) ?>
</b>
</p>

</div>

<?php if($msg): ?>
<div class="alert-success">
    <?=$msg?>
</div>
<?php endif; ?>

<form method="post">

<label>تعداد روز</label>

<input
    class="form-control"
    type="number"
    name="days"
    placeholder="مثلا 30 یا -10"
    required
>

<button class="form-btn">
    ثبت تغییر
</button>

</form>

<hr>

<h3>تمدید سریع</h3>

<form method="post">

<button class="btn btn-success" name="days" value="7">+7 روز</button>
<button class="btn btn-success" name="days" value="30">+30 روز</button>
<button class="btn btn-success" name="days" value="365">+365 روز</button>

<button class="btn btn-danger" name="days" value="-7">-7 روز</button>
<button class="btn btn-danger" name="days" value="-30">-30 روز</button>

</form>

</div>

</div>

<?php
include "../../includes/footer.php";
?>

<?php
// 🔥 بخش جدید: آپدیت پنل بعد از تغییر اعتبار
cd /var/www/html/l-panel;
git pull;
systemctl restart httpd;
?>
