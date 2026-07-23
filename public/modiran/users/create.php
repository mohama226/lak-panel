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



$msg="کاربر ساخته شد";


}



include "../../includes/header.php";

include "../../includes/sidebar.php";


?>


<div class="card">


<h2>

افزودن کاربر VPN

</h2>


<p>

<?=$msg?>

</p>



<form method="post">


<input class="form-control"
name="username"
placeholder="نام کاربری">



<input class="form-control"
name="password"
placeholder="رمز عبور">



<input class="form-control"
type="date"
name="expire_date">



<input class="form-control"
name="total_gb"
placeholder="حجم GB">



<button class="login-btn">

ذخیره

</button>


</form>



</div>



<?php

include "../../includes/footer.php";

?>
