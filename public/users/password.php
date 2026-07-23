<?php


require "../../app/user_auth.php";

checkUserLogin();


require "../../app/database.php";


$msg="";


$id=$_SESSION['vpn_user'];



if($_POST){


$pass=$_POST['password'];



$hash=password_hash(

$pass,

PASSWORD_DEFAULT

);



$stmt=$db->prepare(

"UPDATE users SET password=? WHERE id=?"

);



$stmt->execute([

$hash,

$id

]);



$msg="رمز تغییر کرد";

}



include "../includes/header.php";


?>


<div class="card">


<h2>

🔐 تغییر رمز عبور

</h2>



<p>

<?=$msg?>

</p>



<form method="post">


<input

class="form-control"

type="password"

name="password"

placeholder="رمز جدید">



<button class="login-btn">

ذخیره

</button>


</form>


</div>



<?php

include "../includes/footer.php";

?>
