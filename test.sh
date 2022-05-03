echo "enter sqlfile name";
read sqlfile;
echo "user database user";
read user;

echo "database";
read database;

mysql -u $user -p $database < $(pwd)/$sqlfile

