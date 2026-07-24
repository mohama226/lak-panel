<?php


function admin_log($db,$action,$target=""){


$admin = $_SESSION['admin'] ?? 'unknown';

$ip = $_SERVER['REMOTE_ADDR'] ?? 'unknown';



$stmt=$db->prepare("
INSERT INTO admin_logs
(admin,action,target_user,ip)
VALUES (?,?,?,?)
");


$stmt->execute([
$admin,
$action,
$target,
$ip
]);


}

?>
