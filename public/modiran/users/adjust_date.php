<?php

require "../../../app/auth.php";

checkLogin();


require "../../../app/database.php";



$id=$_POST['id'];

$days=$_POST['days'];



$stmt=$db->prepare(

"SELECT expire_date FROM users WHERE id=?"

);


$stmt->execute([$id]);


$user=$stmt->fetch();



$current=$user['expire_date'];



$newdate=date(

"Y-m-d",

strtotime(

$current." ".$days." days"

)

);



$update=$db->prepare(

"UPDATE users

SET expire_date=?

WHERE id=?"

);



$update->execute([

$newdate,

$id

]);



header(

"Location: /modiran/users"

);


exit;

?>
