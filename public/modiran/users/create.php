<?php

require "../../../app/auth.php";
checkLogin();

require "../../../app/database.php";


$msg="";


if($_POST){

$username=$_POST['username'];
$password=$_POST['password'];
$expire=$_POST['expire_date'];
$volume=$_POST['total_gb'];


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


$msg="کاربر با موفقیت ساخته شد";

}


include "../../includes/header.php";
include "../../includes/sidebar.php";

?>


<div class="main">


<div class="form-card">


<h2>
➕ افزودن کاربر VPN
</h2>


<?php if($msg): ?>

<div class="alert-success">

<?=$msg?>

</div>

<?php endif; ?>



<form method="post">


<div class="form-group">

<label>
نام کاربری
</label>

<input 
class="form-control"
name="username"
required>

</div>



<div class="form-group">

<label>
رمز عبور
</label>

<input 
class="form-control"
name="password"
required>

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
حجم مجاز GB
</label>

<input 
class="form-control"
name="total_gb">

</div>



<button class="btn-primary">

ساخت کاربر

</button>


</form>


</div>


</div>


<?php

include "../../includes/footer.php";

?>
