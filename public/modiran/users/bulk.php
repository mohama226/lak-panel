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


?>


<div class="container">


<div class="page-title">

افزودن گروهی کاربران VPN

</div>




<div class="panel-card">


<?php if($msg): ?>

<div class="success-message">

<?=$msg?>

</div>

<?php endif; ?>





<form method="post">


<div class="grid-form">



<div class="form-group">


<label>
پیشوند کاربران
</label>


<input
class="form-input"
name="prefix"
placeholder="مثال: user">


</div>





<div class="form-group">


<label>
تعداد کاربران
</label>


<input
class="form-input"
name="count"
placeholder="مثال: 100">


</div>





<div class="form-group">


<label>
تاریخ انقضا
</label>


<input
class="form-input"
type="date"
name="expire_date">


</div>





<div class="form-group">


<label>
حجم مجاز GB
</label>


<input
class="form-input"
name="total_gb"
placeholder="مثال: 50">


</div>



</div>



<br>


<button class="btn btn-success">

ساخت کاربران

</button>



</form>



</div>


</div>



<?php

include "../../includes/footer.php";

?>
