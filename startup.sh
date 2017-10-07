cd `dirname $0`

docker rm epgstation
docker rm mysql
docker rm mirakurun

docker run  \
-e MYSQL_USER=epgstation \
-e MYSQL_PASSWORD:=epgstation \
-e MYSQL_ROOT_PASSWORD=epgstation \
-e MYSQL_DATABASE=epgstation \
-e TZ=Asia/Tokyo \
-v dockermirakurunepgstation_mysql-db:/var/lib/mysql \
--restart=always \
--name mysql -i -t -d mysql:8.0 \
mysqld --character-set-server=utf8 --collation-server=utf8_unicode_ci --performance-schema=false

docker run  \
-v /etc/localtime:/etc/localtime:ro \
-v `pwd`/mirakurun/conf:/usr/local/etc/mirakurun \
-v `pwd`/mirakurun/db:/usr/local/var/db/mirakurun \
--privileged \
--device=/dev/pt3video0:/dev/pt3video0 \
--device=/dev/pt3video1:/dev/pt3video1 \
--device=/dev/pt3video2:/dev/pt3video2 \
--device=/dev/pt3video3:/dev/pt3video3 \
-p 40772:40772 \
--restart=always \
--name mirakurun -i -t -d dockermirakurunepgstation_mirakurun

nvidia-docker run \
-v /etc/localtime:/etc/localtime:ro \
-v `pwd`/epgstation/config:/usr/local/EPGStation/config \
-v `pwd`/epgstation/data:/usr/local/EPGStation/data \
-v `pwd`/epgstation/thumbnail:/usr/local/EPGStation/thumbnail \
-v `pwd`/epgstation/logs:/usr/local/EPGStation/logs \
-v `pwd`/recorded:/usr/local/EPGStation/recorded \
-p 8888:8888 \
--link mysql:mysql \
--link mirakurun:mirakurun \
--restart=always \
--name epgstation -i -t -d dockermirakurunepgstation_epgstation

