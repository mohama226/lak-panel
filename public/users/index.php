<?php


require "../../app/database.php";


session_start();


$error="";



if($_POST){


$username=$_POST['username'];

$password=$_POST['password'];



$stmt=$db->prepare(

"SELECT * FROM users WHERE username=?"

);



$stmt->execute([$username]);



$user=$stmt->fetch();



if(

$user &&

$user['status']=="active" &&

password_verify($password,$user['password'])

){


$_SESSION['vpn_user']=$user['username'];

$_SESSION['vpn_id']=$user['id'];



header("Location: dashboard.php");


exit;



}else{


$error="اطلاعات ورود اشتباه است یا حساب مسدود شده";


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


<div class="logo">


<h1>

L-PANEL

</h1>


<span>

VPN User Panel

</span>


</div>



<?php if($error): ?>


<div class="error">

<?=$error?>

</div>


<?php endif; ?>



<form method="post">


<input

class="form-control"

name="username"

placeholder="نام کاربری VPN"



>



<input

class="form-control"

type="password"

name="password"

placeholder="رمز عبور"



>



<button class="login-btn">

ورود

</button>



</form>



</div>



</body>

</html>
