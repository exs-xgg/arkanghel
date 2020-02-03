
#!/bin/bash
echo "[ ~ ] Creating backup of current database"
sh /var/tmp/backup.sh


echo "[ ~ ] Initializing Access Parameters to remote update server"
git config --global user.email "wahph@wah.ph"
git config --global user.name "wahph"
cd /var/www/html/wah2

git config credential.helper store
echo "[ ~ ] Attempting to fix code conflicts"

echo > composer.lock
git add .
git commit -m "purge composer.lock"

echo '********************************'
echo "[ ~ ] Updating server..."
echo '********************************'

git fetch http://wah4update:wah4update2019@gitlab.wah.ph/wahdev/wah2.git misuwahv3
git checkout misuwahv3
composer dump-autoload
php artisan migrate
php artisan clear-compile
php artisan optimize
php artisan cache:clear


echo '********************************'
echo '[ ~ ] Finalizing updates'
sed -i 's/119.92.200.11/eclaimslive2.philhealth.gov.ph/g' /var/www/html/wah2/.env