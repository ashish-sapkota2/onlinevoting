<?php

$connection = new mysqli("localhost","root","","election");
	
	$uid = $_POST['uid'];
    $rid = $_POST['rid'];
    $image = $_POST['image']; 
    $name = $_POST['name'];
    $email = $_POST['email'];
    $phone=$_POST['phone'];
    $gender=$_POST['gender'];
    $faculty=$_POST['faculty'];
    $imagefile = "../images/$phone.jpg" ;
    $imagePath="images/$phone.jpg";
    $filehandler = fopen($imagefile, 'wb' );
    fwrite($filehandler, base64_decode($image));
    fclose($filehandler);

	
	$connection->query("UPDATE user SET rid='2', name='".$name."', email='".$email."', phone='".$phone."', gender='".$gender."',faculty='".$faculty."', image='".$image."', agenda='' WHERE uid=". $uid);
    if (mysqli_query($connection, $sql)){
        echo "Edit Successful";
        }
        else
        {
        echo "Error: " . $sql . "<br>" . mysqli_error($connection);
        }

?>