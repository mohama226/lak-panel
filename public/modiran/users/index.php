<?php

require "../../../app/auth.php";
checkLogin();

require "../../../app/database.php";


$search="";


if(isset($_GET['search'])){

    $search=trim($_GET['search']);

}



if($search){


$stmt=$db->prepare(
"
SELECT * FROM users
WHERE username LIKE ?
ORDER BY id DESC
"
);


$stmt->execute([
"%".$search."%"
]);



}else{


$stmt=$db->prepare(
"
SELECT * FROM users
ORDER BY id DESC
"
);


$stmt->execute();


}



$users=$stmt->fetchAll();



include "../../includes/header.php";

include "../../includes/sidebar.php";

?>


<div class="content">


<div class="users-box">



<div class="users-header">


<h2 class="users-title">

👥 مدیریت کاربران VPN

</h2>


<a class="btn btn-primary"
href="/modiran/users/create.php">

➕ افزودن کاربر

</a>


<a class="btn btn-success"
href="/modiran/users/bulk.php">

👥 افزودن گروهی

</a>


</div>




<form method="get">


<input

class="search-box"

name="search"

value="<?=htmlspecialchars($search)?>"

placeholder="🔍 جستجو نام کاربر ...">


</form>





<div class="table-box">


<table>


<thead>


<tr>

<th>
ID
</th>


<th>
نام کاربری
</th>


<th>
انقضا
</th>


<th>
حجم
</th>


<th>
دانلود
</th>


<th>
آپلود
</th>


<th>
وضعیت
</th>


<th>
عملیات
</th>


</tr>


</thead>



<tbody>



<?php foreach($users as $u): ?>


<tr>


<td>

<?=$u['id']?>

</td>



<td>

<?=$u['username']?>

</td>




<td>

<?=$u['expire_date']?>

</td>




<td>

<?=$u['total_gb'] ?? 0?>

 GB

</td>




<td>

<?=$u['download'] ?? 0?>

 MB

</td>



<td>

<?=$u['upload'] ?? 0?>

 MB

</td>




<td>


<?php if(isset($u['status']) && $u['status']=="blocked"): ?>


<span class="status-danger">
بلاک
</span>


<?php else: ?>


<span class="status-success">
فعال
</span>


<?php endif; ?>


</td>




<td>


<a class="btn btn-primary"

href="/modiran/users/edit.php?id=<?=$u['id']?>">

✏ ویرایش

</a>



<a class="btn btn-success"

href="/modiran/users/extend.php?id=<?=$u['id']?>">

⏱ تمدید

</a>



<a class="btn btn-danger"

href="/modiran/users/delete.php?id=<?=$u['id']?>"

onclick="return confirm('حذف شود؟')">

🗑 حذف

</a>



</td>


</tr>


<?php endforeach; ?>



</tbody>


</table>


</div>



</div>


</div>



<?php

include "../../includes/footer.php";

?>
