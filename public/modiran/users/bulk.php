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
"
INSERT INTO users
(username,password,expire_date,total_gb)
VALUES
(?,?,?,?)
"
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


?>


<main class="content">


<div class="card form-card">


<h2>
👥 افزودن گروهی کاربران
</h2>



<?php if($msg): ?>

<div class="success">

<?=$msg?>

</div>

<?php endif; ?>



<form method="post">



<label>
پیشوند کاربران
</label>


<input
class="form-control"
name="prefix"
placeholder="مثلا user"
required
>



<label>
تعداد کاربران
</label>


<input
class="form-control"
type="number"
name="count"
placeholder="مثلا 100"
required
>



<label>
تاریخ انقضا
</label>


<input
class="form-control"
type="date"
name="expire_date"
required
>



<label>
حجم GB
</label>


<input
class="form-control"
name="total_gb"
placeholder="مثلا 100"
required
>



<button class="login-btn">

ساخت کاربران

</button>


</form>


</div>


</main>



<?php

include "../../includes/footer.php";

?>
