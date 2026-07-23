<?php


require "../../../app/auth.php";
checkLogin();


require "../../../app/database.php";


$msg="";


if($_POST){


$prefix=$_POST['prefix'];

$count=$_POST['count'];

$expire=$_POST['expire_date'];

$volume=$_POST['total_gb'];



for($i=1;$i<=$count;$i++){


$username=$prefix.str_pad(
$i,
3,
"0",
STR_PAD_LEFT
);



$password=substr(
bin2hex(random_bytes(5)),
0,
8
);



$hash=password_hash(
$password,
PASSWORD_DEFAULT
);



$stmt=$db->prepare(
"INSERT INTO users
(username,password,expire_date,total_gb)
VALUES
(?,?,?,?)"
);



$stmt->execute([
$username,
$hash,
$expire,
$volume
]);


}



$msg=$count." کاربر ساخته شد";


}


include "../../includes/header.php";

include "../../includes/sidebar.php";

<main class="content">


<div class="card form-card">
  
?>


<div class="main">


<div class="form-card">


<h2>
👥 افزودن گروهی کاربران
</h2>



<?php if($msg): ?>

<div class="alert-success">

<?=$msg?>

</div>

<?php endif; ?>



<form method="post">



<div class="form-group">

<label>
پیشوند کاربران
</label>


<input 
class="form-control"
name="prefix"
placeholder="مثلا user">

</div>



<div class="form-group">

<label>
تعداد کاربران
</label>


<input 
class="form-control"
name="count">

</div>



<div class="form-group">

<label>
تاریخ انقضا
</label>


<input 
class="form-control"
type="date"
name="expire_date">

</div>



<div class="form-group">

<label>
حجم GB
</label>


<input 
class="form-control"
name="total_gb">

</div>



<button class="btn-primary">

ساخت کاربران

</button>


</form>


</div>


</div>



<?php

</div>

</main>
  
include "../../includes/footer.php";

?>
