<?php

require "../../../app/auth.php";
checkLogin();

require "../../../app/database.php";
require "../../../app/jalali.php";

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

<!-- 🔥 بخش جدید: نمایش تاریخ شمسی -->
<p>
تاریخ شمسی:
<b>
<?= jalali_date($user['expire_date']) ?>
</b>
</p>

<label>حجم مجاز GB</label>
<input class="form-control" name="total_gb" value="<?=$user['total_gb']?>">

<button class="login-btn">
ذخیره تغییرات
</button>

</form>

</div>

</main>

<?php
include "../../includes/footer.php";
?>
