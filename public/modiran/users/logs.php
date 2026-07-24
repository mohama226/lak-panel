<?php

require "../../../app/auth.php";
checkLogin();

require "../../../app/database.php";

$id = $_GET['id'] ?? 0;

$stmt = $db->prepare("
SELECT *
FROM users
WHERE id=?
");

$stmt->execute([$id]);

$user = $stmt->fetch();

if(!$user){
    die("User not found");
}

include "../../includes/header.php";
include "../../includes/sidebar.php";

$username = $user['username'];

?>

<div class="content">

<div class="users-box">

<h2>
📊 لاگ کاربر:
<?=$username?>
</h2>

<div class="table-box">

<h3>
OCServ Logs
</h3>

<pre style="
background:#111;
color:#0f0;
padding:20px;
border-radius:10px;
direction:ltr;
text-align:left;
max-height:500px;
overflow:auto;
">

<?php

$log = shell_exec(
    "grep " . escapeshellarg($username) . " /var/log/ocserv.log | tail -100"
);

echo htmlspecialchars(
    $log ?: "No logs found"
);

?>

</pre>

<h3>
Panel Logs
</h3>

<pre style="
background:#111;
color:#0ff;
padding:20px;
border-radius:10px;
direction:ltr;
text-align:left;
max-height:500px;
overflow:auto;
">

<?php

$stmt = $db->prepare("
SELECT *
FROM admin_logs
WHERE target_user=?
ORDER BY id DESC
LIMIT 100
");

$stmt->execute([$username]);

$logs = $stmt->fetchAll();

if(!$logs){
    echo "No panel logs found";
} else {
    foreach($logs as $l){
        echo htmlspecialchars(
            "[".$l['created_at']."] ".
            $l['admin']." — ".
            $l['action']." — ".
            $l['description']
        ) . "\n";
    }
}

?>

</pre>

</div>

</div>

</div>

<?php
include "../../includes/footer.php";
?>
