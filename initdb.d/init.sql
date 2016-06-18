CREATE DATABASE IF NOT EXISTS mogilefs;
GRANT ALL PRIVILEGES ON mogilefs.* TO 'mogile'@'%' IDENTIFIED BY '123456';
flush privileges;
