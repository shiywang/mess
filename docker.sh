//添加网卡  
brctl addbr br0  
//up网卡  
ip link set br0 up  
//为br0设置ip地址，地址为当前机器eth0的地址，同时把eth0的地址删掉，然后把eth0连到网桥br0上；删除原来（到eth0的）默认路由规则，并添加默认路由规则到br0，via后边的ip，可以先通过ip route查看应该是什么；由于此命令会导致网络连接中断，如果是远程登录到机器上执行的，需要一步执行  
ip addr add 172.16.30.131/24 dev br0; \  
ip addr del 172.16.30.131/24 dev eth0; \  
brctl addif br0 eth0; \  
ip route del default; \  
ip route add default via 172.16.30.2 dev br0  
//跑个容器，不用docker提供的网络（--net=none)，并获取容器id  
docker run -itd --name my-ubuntu --net=none ubuntu:14.04 /bin/bash  
cpid=$(docker inspect --format '{{.State.Pid}}' my-ubuntu)  
//把容器的net ns软连接到/var/run/netns下  
ln -s /proc/$cpid/ns/net /var/run/netns/$cpid  
//添加网卡peer  
ip link add veth-a type veth peer name veth-b  
//把虚拟网卡veth-a添加到br0，并启用  
brctl addif br0 veth-a  
ip link set veth-a up  
//把虚拟网卡veth-b添加到容器网络ns下  
ip link set veth-b netns $cpid  
//修改容器中虚拟网卡veth-b的名称为eth0  
ip netns exec $cpid ip link set veth-b name eth0  
//启用eth0  
ip netns exec $cpid ip link set eth0 up  
//给容器分配ip地址，此地址跟宿主机在同一ip段  
ip netns exec $cpid ip addr add 172.16.30.132/24 dev eth0  
//分配完地址后，设置默认路由  
ip netns exec $cpid ip route add default via 172.16.30.2  
