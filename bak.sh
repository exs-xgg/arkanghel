#!/bin/bash

eval git config --global user.email "wahph@wah.ph"
sleep 1
eval git config --global user.name "wahph"
sleep 1
cd /var/www/html/wah2
echo "updating Misuwah Server. . ."
sleep 3
echo "Please type wah credential. . ."
sleep 2
eval git config credential.helper store
sleep 3
eval git checkout -- .
sleep 3
eval git checkout -b m3-updates
sleep 3
eval git pull origin m3-updates
echo "Update Complete"
sleep 2
echo "Migrating Database. . . ."
eval php artisan migrate
sleep 2
eval composer dump-autoload
sleep 2
eval php artisan clear-compile
sleep 2
eval php artisan optimize
sleep 2
eval php artisan cache:clear
sleep 2
echo "Updating to MISUWAH V3.0 is now complete!"
sleep 2
sed -i 's/119.92.200.11/eclaimslive2.philhealth.gov.ph/g' /var/www/html/wah2/.env
sleep 3
eval rm -r ~/Downloads/Auto
sleep 3
eval rm -r ~/Downloads/Misuwah3.0.zip
echo "Thank You!"
sleep 3




