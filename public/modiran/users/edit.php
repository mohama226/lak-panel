<?php

require "../../../app/auth.php";

checkLogin();


require "../../../app/database.php";


$id=$_GET['id'];



$stmt=$db->prepare(

"SELECT * FROM users WHERE id=?"

);


$stmt->execute([$id]);


$user=$stmt->fetch();



if($_POST){



$status=$_POST['status'];

$volume=$_POST['total_gb'];

$expire=$_POST['expire_date'];



$update=$db->prepare(

"UPDATE users SET

status=?,

total_gb=?,

expire_date=?

WHERE id=?"

);



$update->execute([

$status,

$volume,

$expire,

$id

]);



header(

"Location: /modiran/users"

);


exit;


}




include "../../includes/header.php";

include "../../includes/sidebar.php";


?>


<div class="card">


<h2>

ویرایش کاربر

<?= $user['username']; ?>

</h2>



<form method="post">



<label>
وضعیت
</label>


<select name="status" class="form-control">


<option value="active"

<?=

$user['status']=="active"?"selected":""

?>

>

فعال

</option>



<option value="blocked"

<?=

$user['status']=="blocked"?"selected":""

?>

>

مسدود

</option>


</select>




<label>

حجم کل

</label>


<input

class="form-control"

name="total_gb"

value="<?= $user['total_gb']; ?>">



<label>

تاریخ انقضا

</label>


<input

class="form-control"

type="date"

name="expire_date"

value="<?= $user['expire_date']; ?>">



<button class="login-btn">

ذخیره

</button>



</form>


</div>



<?php

include "../../includes/footer.php";

?>
