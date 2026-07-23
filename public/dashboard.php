<?php

require "../app/auth.php";

checkLogin();

include "includes/header.php";

include "includes/sidebar.php";

?>


<h2>
سلام <?=$_SESSION['admin']?>
</h2>


<div class="row mt-4">


<div class="col-md-4">

<div class="card p-4 shadow">

<h5>
کاربران
</h5>

<h2>
0
</h2>

</div>

</div>



<div class="col-md-4">

<div class="card p-4 shadow">

<h5>
اتصالات فعال
</h5>

<h2>
0
</h2>

</div>

</div>



<div class="col-md-4">

<div class="card p-4 shadow">

<h5>
سرورها
</h5>

<h2>
1
</h2>

</div>

</div>


</div>


<?php

include "includes/footer.php";

?>
