<?php

require "../../app/user_auth.php";
checkUserLogin();

require "../../app/database.php";
require "../../app/jalali.php";
require "../../app/user_helper.php";

$id = $_SESSION['vpn_user'];

$stmt = $db->prepare("SELECT * FROM users WHERE id=?");
$stmt->execute([$id]);
$user = $stmt->fetch();

$download = $user['download'] ?? 0;
$upload   = $user['upload'] ?? 0;

$total_mb = $user['total_gb'] * 1024;
$used     = $download + $upload;

$percent = volume_percent($used, $total_mb);
$days    = remaining_days($user['expire_date']);

include "../includes/header.php";

?>

<div class="content">

<div class="users-box">

<h2>👤 پنل کاربری</h2>

<div class="card">

<p>
نام کاربری:
<b><?=$user['username']?></b>
</p>

<p>
تاریخ انقضا میلادی:
<b><?=$user['expire_date']?></b>
</p>

<p>
تاریخ انقضا شمسی:
<b><?=jalali_date($user['expire_date'])?></b>
</p>

<p>
حجم کل:
<b><?=$user['total_gb']?> GB</b>
</p>

<p>
دانلود:
<b><?=($user['download'] ?? 0)?> MB</b>
</p>

<p>
آپلود:
<b><?=($user['upload'] ?? 0)?> MB</b>
</p>

</div>

<!-- 🔥 کارت جدید: اعتبار -->
<div class="card">

<h3>⏳ اعتبار</h3>

<p>
روز باقی مانده:
<b><?=$days?> روز</b>
</p>

</div>

<!-- 🔥 کارت جدید: مصرف حجم -->
<div class="card">

<h3>📊 مصرف حجم</h3>

<p>
مصرف شده:
<b><?=$used?> MB</b>
از
<b><?=$total_mb?> MB</b>
</p>

<div class="progress">
    <div class="progress-bar" style="width:<?=$percent?>%"></div>
</div>

<p><?=$percent?> %</p>

</div>

</div>

</div>

<?php
include "../includes/footer.php";
?>
