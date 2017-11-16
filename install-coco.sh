作者：无心漫漫
链接：https://www.zhihu.com/question/24632288/answer/63017862
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

#!/bin/bash
sleep 5s
sudo apt-get update

sleep 5s
sudo apt-get -y install make build-essential curl git zlib1g-dev python2.7 libkrb5-dev

sleep 5s
sudo mkdir -p coco
cd coco
sudo git clone https://github.com/codecombat/codecombat.git

sleep 5s
sudo wget http://nodejs.org/dist/v5.1.1/node-v5.1.1.tar.gz
sudo tar xfz node-v5.1.1.tar.gz
cd node-v5.1.1
sudo ./configure
sudo make
sudo make install

cd ~/coco/codecombat
sudo npm config set registry https://registry.npm.taobao.org
sudo npm config set python python2.7
sudo npm install -g bower
sudo npm install -g brunch
sudo npm install -g geoip-lite
sudo npm install -g nodemon
sudo npm install -g coffee-script@1.9.x
sudo npm install -g uglify-js@2.5.0
sudo SASS_BINARY_SITE=https://npm.taobao.org/mirrors/node-sass/ npm install --phantomjs_cdnurl=http://cnpmjs.org/downloads

sleep 5s
sudo bower --allow-root install
sudo brunch build --env fast
sleep 5s
cd ~/coco && mkdir -p mongodl
cd mongodl
sudo curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1404-3.2.6.tgz
sudo tar xfz mongodb-linux-x86_64-ubuntu1404-3.2.6.tgz
sudo cp mongodb-linux-x86_64-ubuntu1404-3.2.6/bin/* /usr/local/bin

sleep 5s
cd ~/coco && mkdir -p db
cd db
sudo wget http://analytics.codecombat.com:8080/dump.tar.gz
sudo tar xzvf dump.tar.gz

sleep 5s
cd ~/coco && mkdir -p log
sudo ./codecombat/bin/coco-mongodb >~/coco/log/mongodb.log 2>&1 &
echo Wait 10 seconds

sleep 10s
cd db && sudo mongorestore --drop dump

sleep 5s
cd ~/coco
cat <<- EOF > run-coco.sh
#!/bin/bash
echo ----------Run brunch and nodemon
cd ~/coco/codecombat
nohup sudo npm run dev >~/coco/log/brunch_nodemon.log 2>&1 &
echo ----------brunch and nodemon ok!
EOF
chmod 777 run-coco.sh

sleep 5s
cd ~/coco
cat <<- EOF > run-mongodb.sh
#!/bin/bash
echo ----------Run mongodb
nohup sudo ~/coco/codecombat/bin/coco-mongodb >~/coco/log/mongodb.log 2>&1 &
echo ----------mongodb ok
EOF
chmod 777 run-mongodb.sh

cat <<- EOF > stop-mongodb.sh
#!/bin/bash
echo ----------Stop mongodb
sudo mongo admin --port 27017 --eval "db.shutdownServer()"
echo ----------Stop Mongodb ok!
EOF
chmod 777 stop-mongodb.sh

echo -------------------------------------------------------------------------
echo ----------ok!
echo --------------------------