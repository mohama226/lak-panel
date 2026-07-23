<?php


session_start();


require "../../app/database.php";



$error="";



if($_POST){



$username=$_POST['username'];

$password=$_POST['password'];



$stmt=$db->prepare(
"SELECT * FROM users WHERE username=?"
);



$stmt->execute([

$username

]);



$user=$stmt->fetch();



if($user && password_verify($password,$user['password'])){


$_SESSION['vpn_user']=$user['id'];



header("Location: /users/dashboard.php");

exit;



}else{


$error="نام کاربری یا رمز عبور اشتباه است";


}



}



?>


<!DOCTYPE html>

<html lang="fa" dir="rtl">

<head>

<meta charset="UTF-8">

<title>
VPN User Login
</title>


<link rel="stylesheet" href="/assets/css/login.css">


</head>


<body>


<div class="login-box">


<h1>
L-PANEL
</h1>


<h3>
ورود کاربران VPN
</h3>



<?php if($error): ?>

<div class="error">

<?=$error?>

</div>

<?php endif; ?>



<form method="post">


<input

class="form-control"

name="username"

placeholder="نام کاربری">



<input

class="form-control"

type="password"

name="password"

placeholder="رمز عبور">



<button class="login-btn">

ورود

</button>


</form>



</div>


</body>


</html>
