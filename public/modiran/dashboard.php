<?php

session_start();


if(!isset($_SESSION['admin'])){

header("Location: /modiran");

exit;

}



include "../includes/header.php";

include "../includes/sidebar.php";


?>


<div class="container">


<div class="topbar">

<h2>
داشبورد مدیریت
</h2>

</div>



<div class="row">


<div class="card">

<h3>
کل کاربران
</h3>


<div class="stat">
0
</div>


<p>
کاربران ثبت شده
</p>


</div>




<div class="card">

<h3>
کاربران فعال
</h3>


<div class="stat">
0
</div>


<p>
حساب فعال
</p>


</div>




<div class="card">

<h3>
ترافیک مصرفی
</h3>


<div class="stat">

0 GB

</div>


<p>
دانلود + آپلود
</p>


</div>



</div>



</div>



<?php

include "../includes/footer.php";

?>
