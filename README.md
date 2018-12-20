# docker-asterisk13-centos7
Asterisk13 rpm by [tucny](https://www.tucny.com/telephony/asterisk-rpms) running on centos 7. It runs /var on external volume an links /etc/asterisk to /var/lib/asterisk/astconfig to save custom configuration. Also you can put any custom module on /var/lib/asterisk/modplus (it is linked to /usr/lib64/asterisk/modules/modplus) and load it to asterisk. This image is not builded with systemd. Enjoy it!


### Pull the image:

**docker pull etates/asterisk13:latest**


### Run the docker:

**docker run -d --name asterisk13 --tmpfs /run -v ast13vol:/var etates/asterisk13:latest**
