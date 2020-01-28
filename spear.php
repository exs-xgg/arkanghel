<?php


#TEST THE WATERS

#PERFORM COMMAND CHECKING
echo "[ ~ ] Checking for existing scripts" . PHP_EOL;
$out = shell_exec("cat ~/.bashrc | grep wahupdate");
$out = explode(" ",$out);
if($out[1]=="'wahupdate'='sudo"){
    echo "[ * ] WAH Assisted Update script found, checking for updates." . PHP_EOL;
    // echo $a = file_get_contents("http://localhost/script_final");
    
}else{
    echo "[ x ] WAH Assisted Update script not found, attempting to install script." . PHP_EOL;
    
    // echo $a = shell_exec("curl http://localhost/script_final > yeet");
    shell_exec("echo 0 > .blood");
}