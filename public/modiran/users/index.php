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
انقضا
</th>


<th>
حجم
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

<?= $user['status']; ?>

</td>



<td>

<?= $user['expire_date']; ?>

</td>



<td>

<?= $user['used_gb']; ?>

/

<?= $user['total_gb']; ?>

GB

</td>




<td>


<a href="delete.php?id=<?= $user['id']; ?>">

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
