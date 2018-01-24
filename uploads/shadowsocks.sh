#!/bin/sh

installSS(){
    #install python34
    if [ `rpm -qa | grep python34 |wc -l` -lt 1 ];then
        sudo yum install -y python34
    fi

    #pip3 install
    pipcheck=`pip3`
    if [ $? != 0 ];then
        curl https://bootstrap.pypa.io/get-pip.py | python3
    fi

    #install shadowsocks
    #if [ ` pip3 list | grep shadowsocks | wc -l` -lt 1 ];then
    if [ `pip3 show shadowsocks | wc -l` -lt 1 ];then
        pip3 install shadowsocks
    fi

    echo '{
        "server":"0.0.0.0",
        "local_address":"127.0.0.1",
        "local_port":1080,
        "port_password":{
             "8989":"password0",
             "9001":"password1",
             "9002":"password2",
             "9003":"password3",
             "9004":"password4"
        },
        "timeout":300,
        "method":"aes-256-cfb",
        "fast_open": false
    }' > /etc/shadowsocks.json

    #输出端口和密码
    echo '端口号：8989密码：password0'
    echo '端口号：9001密码：password1'
    echo '端口号：9002密码：password2'
    echo '端口号：9003密码：password3'
    echo '端口号：9004密码：password4'

    ssserver -c /etc/shadowsocks.json -d start
}

#卸载ss
uninstallSS(){
    #rm config
    rm -rf /etc/shadowsocks.json

    #stop service
    ssserver -d stop

    #uninstall shadowsocks
    if [ `pip3 show shadowsocks | wc -l` -ne 0 ];then
        pip3 uninstall shadowsocks
    fi

    #uninstall python34
    if [ `rpm -qa | grep python34 |wc -l` -ne 0 ];then
        sudo yum remove -y python34
    fi
}

read -p '安装y卸载n不操作c：\n' i
if [ "$i"x = 'y'x ];then
   installSS
elif [ "$i"x = 'n'x ];then
    uninstallSS
fi