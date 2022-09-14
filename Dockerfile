FROM alpine

ENV DEBIAN_FRONTEND noninteractive
## Define contraseña de root
ENV ROOTPASS=12345
RUN apk update
RUN apk add supervisor

### Instalar todo lo necesario ###
RUN apk add openssh git npm nodejs python3 py-pip

### Crea archivos de Supervisor ### (No editar)
RUN echo "[supervisord]" >> /etc/supervisord.conf
RUN echo "nodaemon=true" >> /etc/supervisord.conf
RUN echo "" >> /etc/supervisord.conf


### SSH - Configura SSH ### (No editar)
RUN mkdir /root/.ssh
RUN ssh-keygen -t rsa -b 4096 -f  /etc/ssh/ssh_host_key
RUN /usr/bin/ssh-keygen -A
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN mkdir /var/run/sshd
## Edite la contraseña root (12345)
RUN echo 'root:12345' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
## SSH - Agrega SSH para iniciar con Supervisor (No editar)
RUN echo "" >> /etc/supervisord.conf
RUN echo "[program:ssh]" >> /etc/supervisord.conf
RUN echo 'command=/usr/sbin/sshd -D' >> /etc/supervisord.conf
RUN echo "[program:hostname]" >> /etc/supervisord.conf
RUN echo "command=hostname alpine" >> /etc/supervisord.conf
RUN echo 'autostart=true' >> /etc/supervisord.conf
RUN echo 'autorestart=false' >> /etc/supervisord.conf

### Desplega App en contenedor ####
### Agrega npm start a supervisor para iniciar en /app/app (Unidad persistente)
RUN echo "" >> /etc/supervisord.conf
RUN echo "[program:nodeapp]" >> /etc/supervisord.conf
RUN echo "command=npm start --prefix /app/app/" >> /etc/supervisord.conf
RUN echo 'autostart=true' >> /etc/supervisord.conf
RUN echo 'autorestart=true' >> /etc/supervisord.conf

## Edite su esta parte y agrege todo lo necesario para desplegar y configurar su APP
## Si su APP no requiere configuración manual solo mueva su app a la carpeta /app/app/
RUN apk add ffmpeg
RUN git clone https://github.com/HirCoir/MediaBot
RUN cd MediaBot && npm install 
RUN mv ../MediaBot /
CMD ["/usr/bin/supervisord"]
