<?php

require "../../../app/auth.php";

checkLogin();


require "../../../app/database.php";



$stmt=$db->query(

"SELECT * FROM users ORDER BY id DESC"

);


$users=$stmt->fetchAll();



include "../../includes/header.php";

include "../../includes/sidebar.php";


?>


<div class="topbar">

<h2>
مدیریت کاربران VPN
</h2>


</div>



<div class="card">


<table width="100%" border="0" cellpadding="15">


<tr>


<th>
ID
</th>


<th>
نام کاربری
</th>


<th>
وضعیت
</th>


<th>
تاریخ انقضا
</th>


<th>
حجم کل
</th>


<th>
دانلود
</th>


<th>
آپلود
</th>


<th>
مصرف کل
</th>


<th>
عملیات
</th>


</tr>



<?php foreach($users as $user): ?>


<tr>


<td>

<?= $user['id']; ?>

</td>



<td>

<?= htmlspecialchars($user['username']); ?>

</td>



<td>

<?= $user['status'] ?? 'active'; ?>

</td>



<td>

<?= $user['expire_date']; ?>

</td>



<td>

<?= $user['total_gb']; ?>

GB

</td>




<td>

<?php

$download = $user['download_mb'] ?? 0;

echo round($download / 1024 , 2);

?>

GB

</td>




<td>

<?php

$upload = $user['upload_mb'] ?? 0;

echo round($upload / 1024 , 2);

?>

GB

</td>





<td>

<?php


$total =

(
($user['download_mb'] ?? 0)
+
($user['upload_mb'] ?? 0)
)
/1024;


echo round($total,2);


?>

GB


</td>





<td>



<a href="edit.php?id=<?= $user['id']; ?>">

ویرایش

</a>



<br><br>




<form method="post" action="adjust_date.php">


<input type="hidden"

name="id"

value="<?= $user['id']; ?>">



<input 

name="days"

placeholder="+30 یا -10"

style="width:100px"

>



<button type="submit">

اعمال

</button>



</form>




<br>



<a href="delete.php?id=<?= $user['id']; ?>"

onclick="return confirm('حذف شود؟')">

حذف

</a>



</td>



</tr>



<?php endforeach; ?>



</table>



</div>




<?php


include "../../includes/footer.php";


?>
