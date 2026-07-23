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



$msg="کاربر با موفقیت ساخته شد";


}



include "../../includes/header.php";

include "../../includes/sidebar.php";

?>


<main class="content">


<div class="card form-card">


<h2>
➕ افزودن کاربر VPN
</h2>



<?php if($msg): ?>

<div class="success">

<?=$msg?>

</div>

<?php endif; ?>



<form method="post">


<label>
نام کاربری
</label>

<input 
class="form-control"
name="username"
placeholder="username"
required>



<label>
رمز عبور
</label>


<input 
class="form-control"
name="password"
placeholder="password"
required>



<label>
تاریخ انقضا
</label>


<input 
class="form-control"
type="date"
name="expire_date"
required>



<label>
حجم مجاز (GB)
</label>


<input 
class="form-control"
name="total_gb"
placeholder="مثلا 100"
required>



<button class="login-btn">

ساخت کاربر

</button>


</form>



</div>


</main>



<?php

include "../../includes/footer.php";

?>
