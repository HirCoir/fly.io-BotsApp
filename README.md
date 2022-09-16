# fly.io-BotsApp
Pasos:
1. Instalar Fly CLI
2. Iniciar sesión con el comando flyctl auth login
3. Abrir terminal, powershell y acceder a la carpeta de la plantilla
4. Renombrar la plantilla a utilizar a Dockerfile
5. Ejecutar "fly deploy" pero no iniciar el deploy para crear el archivo de configuración "fly.toml"
Cuanto nos aparezca "Would you like to deploy now? (y/N)" escribimos "n" y pulsamos enter.
6. Editar archivo "fly.toml" y  debajo de [env] eliminar el resto y agregar la siguiente línea:

```
[experimental]
  allowed_public_ports = []
  auto_rollback = true

[mounts]
  destination = "/app"
  source = "myapp_data"


[[services]]
  internal_port = 22
  protocol = "tcp"

  [[services.ports]]
    port = 22

[[services]]
  http_checks = []
  internal_port = 8080
  processes = ["app"]
  protocol = "tcp"
  script_checks = []
  [services.concurrency]
    hard_limit = 25
    soft_limit = 20
    type = "connections"

  [[services.ports]]
    handlers = ["http"]
    port = 80

  [[services.tcp_checks]]
    grace_period = "1s"
    interval = "15s"
    restart_limit = 0
    timeout = "2s"
```

7. Crear una unidad persistente con el comando "fly volumes create myapp_data --region lhr --size 1"
Es importante tener en cuenta que en total solo podemos tener 3GB en total de unidades persistente
pero lo recomendable es tener solo 1GB.

8. Ejecutamos "fly launch" para desplegar el contenedor de nuesta APP.
Es importante que su app esté dentro de la carpeta "/app" ya que ahí es donde se montó la unidad persistente.


