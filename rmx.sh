#!/bin/bash
#script written by romeo manuel e. david.
#  _____  __  ____   __   _____ ____  _   _ ______ _____ _____ 
# |  __ \|  \/  \ \ / /  / ____/ __ \| \ | |  ____|_   _/ ____|
# | |__) | \  / |\ V /  | |   | |  | |  \| | |__    | || |  __ 
# |  _  /| |\/| | > <   | |   | |  | | . ` |  __|   | || | |_ |
# | | \ \| |  | |/ . \  | |___| |__| | |\  | |     _| || |__| |
# |_|  \_\_|  |_/_/ \_\  \_____\____/|_| \_|_|    |_____\_____|
#                                                              
                                                              
fx_print_init(){
    echo "Welcome to RMX Automated WAHFFLE configurator"
    echo "To view this command's man page, type 'rmxconfig --man'"
}
fx_print_xml(){

cat <<EOT > ./config.xml
<?xml version="1.0"?>
<config>
    <node>
        <name>$FACILITYNAME</name>
        <code>$CODE</code>
        <telephone></telephone>
        <level>self</level>
        <hfid>$HFID</hfid>
        <accred>$ACCRED</accred>
        <prc>$PRC</prc>
        <lastname>$LASTNAME</lastname>
        <firstname>$FIRSTNAME</firstname>
        <middlename>$MIDDLENAME</middlename>
        <suffix>NA</suffix>
        <wkey>$WKEY</wkey>
        <ekey>$EKEY</ekey>
        <wsdl>https://119.92.200.12/webservice/index.php?wsdl</wsdl>
    </node>
    <node>
        <name>$FACILITYNAME</name>
        <code>$CODE</code>
        <telephone></telephone>
        <level>parent</level>
        <hfid>$HFID</hfid>
    </node>
    <node>
        <name>$FACILITYNAME</name>
        <code>$CODE</code>
        <telephone></telephone>
        <level>child</level>
        <hfid>$HFID</hfid>
    </node>
</config>
EOT
}
fx_proceed(){

    #initialize database
    echo ""
    echo "==================="
    echo "[+] CREATING DATABASE QUERIES"


    # string=`cat $SQLENV | head -1`

    # if [[ $string = *"MySQL"* ]]; then
    #     echo "[+] Database is encrypted. Decrypting now."
    #     cat $SQLENV | ccrypt -d -k ~/.ekey > ${SQLENV}.dc
    #     SQLENV=${SQLENV}.dc
    
    # fi

    sudo echo "create database $SQLDBNAME; " > configsql.sql
    echo "use $SQLDBNAME;" >> configsql.sql
    sudo cat $SQLENV >> configsql.sql
    sudo cat mod.sql >> configsql.sql
    echo "[+] EXECUTING DATABASE QUERIES"
    sudo mysql -uroot -proot < configsql.sql
    echo "[+] DATABASE SETUP SUCCESSFUL"


    #initialize environment
    echo "[+] SETTING UP FOLDER"
    sudo cp -R /var/www/wahmapandan /var/www/$FOLDERNAME
    sudo cat ./_dbselect.php > ./dbdb.php
    echo "[+] SETTING UP _dbselect"
    sudo sed -i -e 's/'"placeholder"'/'"$SQLDBNAME"'/g' ./dbdb.php
    sudo cat dbdb.php > /var/www/$FOLDERNAME/modules/_dbselect.php

    #initialize xml
    echo "[+] SETTING UP config.xml"
    fx_print_xml
    sudo cat config.xml > /var/www/$FOLDERNAME/config.xml
    echo "[+] SETTING UP permissions"
    sudo chmod 777 /var/www/$FOLDERNAME
    echo ""
    echo "[+] Injecting RHU to Reports Generator"
    sudo echo "\"${FACILITYNAME}\" => \"$SQLDBNAME\", " >> /var/www/2017/hf.php
    echo "====================="
    echo "Done setting up!"
    echo ""

}
fx_out_all(){
    echo ""
    echo ""
    echo "Review all inputs before proceeding."
    echo "Health Facility Name: $FACILITYNAME" 
    echo "Folder Name: /var/www/$FOLDERNAME" 
    echo "SQL Link: $SQLLINK"
    read -p "Press ENTER key to proceed to config.xml review. Press Ctrl + C to abort"
    fx_print_xml
    cat ./config.xml
    echo ""
    echo "================="
    read -e -p "Is everything ok? [y/n]: " DECISION
    if [ "$DECISION" == "y" ]; then
        fx_proceed
    elif [ "$DECISION" == "Y" ]; then
        fx_proceed
    else
        echo "Bye nigga."
        exit 1
    fi
}
fx_print_man(){
    if [ "$EUID" -ne 0 ]
      then echo "Please run as root"
      exit
    fi
    echo "=================================="
    echo "Welcome to RMX Automated WAHFFLE configurator"
    echo "This script automates most of the process configuration including MySQL configuration and folder config."
    echo "=================================="
    echo ""
    echo "IMPORTANT: You should run this with sudo."
    echo "# sudo ./rmxconfig.sh --init-script"
    echo ""
    echo "=================================="
    echo ""
}
fx_do_get_vars(){
    echo "Welcome to RMX Automated WAHFFLE configurator"
    echo "Input what is asked. Abort (Ctrl + C) if mistake was committed."

    SQLENV="/home/waffle-server/Downloads/"
    #create /var/www/folder
    read -e -p "/var/www folder name: " FOLDERNAME
    
    #get sql link
    read -e -p "SQL File name: /home/waffle-server/Downloads/" SQLLINK

    
    #join path with sql file name
    SQLENV="$SQLENV$SQLLINK"
    if [ ! -f $SQLENV ]; then
        echo "[x] SQL File not found. Exiting..."
        echo ""
        exit
    fi
    IFMLIBEXISTS=`cat $SQLENV | grep m_lib | head -1`

    
    if [[ $IFMLIBEXISTS = *"m_lib"* ]]; then
    echo ""
    #issue here???
    else
        echo "[-] WARNING: DATABASE FORMAT INVALID. DOESNT CONTAIN M_LIB TABLES OR IS ENCRYPTED"
   #     echo "Exiting now..."
   #     echo ""
   #     echo ""
   #     exit
    fi
    read -e -p "SQL Database Name: " SQLDBNAME

    read -e -p "BRGY CODE (10 DIGITS. If kulang, dagdagan ng mga 0 sa harap): " CODE

    read -e -p "DOH HF ID: " HFID
    read -e -p "Health Facility: " FACILITYNAME

    

    #config SQL
    read -e -p "WEB SERVICE KEY: " WKEY
    read -e -p "ENCRYPTION KEY: " EKEY
    read -e -p "PCB ACCREDITATION ID: " ACCRED
    read -e -p "MHO FIRST NAME: " FIRSTNAME
    read -e -p "MHO MIDDLE NAME: " MIDDLENAME
    read -e -p "MHO LAST NAME: " LASTNAME
    read -e -p "PRC CODE: " PRC
    fx_out_all
}

fx_do_get_vars

#1382 menu id
