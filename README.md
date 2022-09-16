# fly.io-BotsApp
Pasos:
1. Instalar Fly CLI
2. Iniciar sesión con el comando flyctl auth login
3. Abrir terminal, powershell y acceder a la carpeta de la plantilla
4. Renombrar la plantilla a utilizar a Dockerfile
5. Ejecutar "fly deploy" pero no iniciar el deploy para crear el archivo de configuración "fly.toml"
Cuanto nos aparezca "Would you like to deploy now? (y/N)" escribimos "n" y pulsamos enter.
6. Editar archivo "fly.toml" y  debajo de [env]  agregar las siguientes línea:

Asignar unidad persistente myapp_data a la ubicación /app
```
[mounts]
  destination = "/app"
  source = "myapp_data"
```

Permitir al contenedor escuchar el puerto SSH externamentee

```
[[services]]
  internal_port = 22
  protocol = "tcp"

  [[services.ports]]
    port = 22
```

7. Crear una unidad persistente con el comando "fly volumes create myapp_data --region lhr --size 1"
Es importante tener en cuenta que en total solo podemos tener 3GB en total de unidades persistente
pero lo recomendable es tener solo 1GB para poder asignar 1GB a los 3 contenedors gratuitos.

8. Ejecutamos "fly launch" para desplegar el contenedor de nuesta APP.
Es importante que su app esté dentro de la carpeta "/app" ya que ahí es donde se montó la unidad persistente.

![alt text](https://i.ibb.co/p2wGpk9/critial-error.jpg)

Finalmente mostrará un mensaje así, se quedará congelada la terminal ya que no ha detectado un protocolo http en el puerto interno (8080)
Solo pulsa Ctrl + C.

9. Accede vía ssh al contenedor.
10. dentro de el accede a la carpeta de BotsApp
```
cd /BotsApp
```
11. Inicia BotsApp
```
npm start
```
12. Escanee el código y ya escaneado detenga el "Bot Ctrl + C"
13. copie el bot a la carpeta /app/app/ para que este inicie automáticamente
```
mv ../BotsApp/ /app/app
```
14. Espere a que inicie y esté en línea.
15. A disfrutar de BotsApp!

