#

#
NODE_URL="http://nodejs.org/dist/v0.10.21/node-v0.10.21.tar.gz"
NODE_TARGET="/tmp/"
NODE_V="node-v0.10.21"
GHOST_URL="https://github.com/TryGhost/Ghost.git"
GHOST_DIR="/opt/ghost"


#
easy_install pip
pip install py-bcrypt

#
wget $NODE_URL -P $NODE_TARGET
tar xvzf /tmp/$NODE_V.tar.gz -C $NODE_TARGET
cd $NODE_TARGET/$NODE_V && ./configure
cd $NODE_TARGET/$NODE_V && make
cd $NODE_TARGET/$NODE_V && make install

#
npm install sqlite3
#

#
git clone $GHOST_URL $GHOST_DIR
#
cd $GHOST_DIR && gem install sass bourbon
#
cd $GHOST_DIR && git submodule update --init
cd $GHOST_DIR && npm install -g grunt-cli
cd $GHOST_DIR && npm install
cd $GHOST_DIR && grunt init
cd $GHOST_DIR && cp config.example.js config.js
cd $GHOST_DIR && npm install -g forever
chown -R www-data:www-data /opt/ghost

#
#
#
crontab /tmp/for_cron.txt

#
/usr/local/bin/ghost-starter.sh
killall node
#
mv /tmp/ghost-dev.db /opt/ghost/content/data/

#
ln -s /etc/nginx/sites-available/ghost /etc/nginx/sites-enabled/ghost
#
rm /etc/nginx/sites-enabled/default
#
/etc/init.d/nginx stop
