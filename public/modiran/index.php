<?php

require_once __DIR__.'/../../app/bootstrap.php';

$error = "";

if($_POST){

    $username = $_POST['username'];
    $password = $_POST['password'];

    $stmt = $db->prepare(
        "SELECT * FROM admins WHERE username=?"
    );

    $stmt->execute([$username]);

    $user = $stmt->fetch();

    if($user && password_verify($password,$user['password'])){

        $_SESSION['admin']=$user['username'];
        $_SESSION['role']=$user['role'];

        writeLog(
            "admin.log",
            "ورود مدیر ".$user['username']
        );

        header("Location: dashboard.php");
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
<title>مدیریت L-PANEL</title>
<link rel="stylesheet" href="../assets/css/login.css">
</head>

<body>

<div class="login-box">

<div class="logo">
    <h1>L-PANEL</h1>
    <span>Admin Login</span>
</div>

<?php if($error): ?>
<div class="error">
    <?=$error?>
</div>
<?php endif; ?>

<form method="post">

<input class="form-control"
       name="username"
       placeholder="نام کاربری">

<input class="form-control"
       type="password"
       name="password"
       placeholder="رمز عبور">

<button class="login-btn">
    ورود مدیر
</button>

</form>

</div>

</body>
</html>
