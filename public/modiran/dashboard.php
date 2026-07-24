<?php

require "../../app/auth.php";
checkLogin();

include "../includes/header.php";
include "../includes/sidebar.php";

?>

<div class="container">

<div class="page-title">
داشبورد مدیریت L-PANEL
</div>

<div class="dashboard-grid">

<div class="dashboard-card">
    <h3>کل کاربران VPN</h3>
    <div class="dashboard-number">0</div>
    <div class="dashboard-text">کاربران ثبت شده</div>
</div>

<div class="dashboard-card">
    <h3>کاربران فعال</h3>
    <div class="dashboard-number">0</div>
    <div class="dashboard-text">اتصال فعال</div>
</div>

<div class="dashboard-card">
    <h3>مصرف ترافیک</h3>
    <div class="dashboard-number">0 GB</div>
    <div class="dashboard-text">دانلود + آپلود</div>
</div>

</div>

<div class="status-box">

<h3>وضعیت سیستم</h3>

<p>
وضعیت پنل:
<span class="status-online">فعال</span>
</p>

<p>
مدیر وارد شده:
<?=htmlspecialchars($_SESSION['admin']);?>
</p>

</div>

</div>

<?php
include "../includes/footer.php";
?>
