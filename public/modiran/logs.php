<?php

require "../../app/auth.php";
checkLogin();

require "../../app/database.php";

include "../includes/header.php";
include "../includes/sidebar.php";


$stmt=$db->query("
SELECT * FROM admin_logs
ORDER BY id DESC
LIMIT 200
");


$logs=$stmt->fetchAll();


?>


<div class="content">


<h2>
📋 لاگ فعالیت مدیران
</h2>


<table>


<tr>

<th>مدیر</th>
<th>عملیات</th>
<th>کاربر</th>
<th>توضیح</th>
<th>زمان</th>

</tr>


<?php foreach($logs as $l): ?>


<tr>

<td><?=$l['admin']?></td>

<td><?=$l['action']?></td>

<td><?=$l['target_user']?></td>

<td><?=$l['description']?></td>

<td><?=$l['created_at']?></td>


</tr>


<?php endforeach; ?>


</table>


</div>



<?php

include "../includes/footer.php";

?>
