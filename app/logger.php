<?php

function writeLog($admin,$action){

global $db;

$stmt=$db->prepare(
"INSERT INTO admin_logs
(admin,action,created_at)
VALUES (?,?,NOW())"
);

$stmt->execute([
$admin,
$action
]);

}
