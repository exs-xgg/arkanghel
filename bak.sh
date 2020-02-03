#!/bin/bash

git config --global user.email "wahph@wah.ph"
git config --global user.name "wahph"
cd /var/www/html/wah2
echo "updating Misuwah Server. . ."
echo "Please type wah credential. . ."
git config credential.helper store
git checkout -- .
git checkout -b m3-updates
git pull origin m3-updates
echo "Update Complete"
echo "Migrating Database. . . ."
php artisan migrate
composer dump-autoload
php artisan clear-compile
php artisan optimize
php artisan cache:clear
echo "Updating to MISUWAH V3.0 is now complete!"
sed -i 's/119.92.200.11/eclaimslive2.philhealth.gov.ph/g' /var/www/html/wah2/.env
rm -r ~/Downloads/Auto
rm -r ~/Downloads/Misuwah3.0.zip
echo "Thank You!"




