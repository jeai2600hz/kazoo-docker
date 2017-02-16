#!/bin/sh
FLAGS=${1:-"-td"}
NETWORK=${NETWORK:-"kazoo"}
KAZOO_APPS=${APPS:-"sysconf,blackhole,callflow,cdr,conference,crossbar,fax,hangups,media_mgr,milliwatt,omnipresence,pivot,registrar,reorder,stepswitch,teletype,trunkstore,webhooks,ecallmgr"}
NAME=kazoo.$NETWORK
if [ -n "$(docker ps -aq -f name=$NAME)" ]
then
	docker stop -t 1 $NAME
	docker rm -f $NAME
fi
echo -n "starting kazoo with apps: $KAZOO_APPS "
docker run $FLAGS \
	--net $NETWORK \
	-h $NAME \
	--name $NAME \
	--env NETWORK=kazoo \
	--env COUCHDB=couchdb.$NETWORK \
	--env RABBITMQ=rabbitmq.$NETWORK \
	--env NODE_NAME=kazoo \
	--env KAZOO_APPS=KAZOO_APPS \
	2600hz/kazoo
