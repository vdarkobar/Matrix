# Matrix
An open network for secure, decentralized communication
  
---
  
To create *element-config.json* use: <a href="https://develop.element.io/config.json">example file</a>, 
remove '"default_server_name": "matrix.org"' (*deprecated*), 
add custom homeserver to the top of file:
```
    "default_server_config": {
        "m.homeserver": {
            "base_url": "https://matrix.example.com",
            "server_name": "matrix.example.com"
        },
        "m.identity_server": {
            "base_url": "https://vector.im"
        }
    },
```
  
To generate *Synapse Config* and run:
```
sudo docker run -it --rm \
    -v "$PWD/synapse:/data" \
    -e SYNAPSE_SERVER_NAME=matrix.example.com \
    -e SYNAPSE_REPORT_STATS=yes \
    matrixdotorg/synapse:latest generate
 ```
  or
 ```
sudo docker run -it --rm \
    -v "$PWD/synapse:/data" \
    -e SYNAPSE_SERVER_NAME=matrix.example.com \
    -e SYNAPSE_REPORT_STATS=yes \
    -e UID=1000 \
    -e GID=1000 \
    matrixdotorg/synapse:latest generate
```
  
Edit: `synapse/homeserver.yaml`:
  
Comment out sqlite database (to be replaced with postgres)
```
#database:
#  name: sqlite3
#  args:
#    database: /data/homeserver.db
```
  
Uncoment ad edit values: 
```
database:
  name: psycopg2
  args:
    user: <db_user from secrets>
    password: <db_password from secrets>
    database: synapse
    host: <postgres container name>
    cp_min: 5
    cp_max: 10
```
  
Other important settings, uncomment/edit:
```
server_name: "matrix.example.com"
web_client_location: https://<subdomain-for-element-web>.example.com
public_baseurl: https://matrix.example.com/
serve_server_wellknown: true
```
  
Deploy
```
sudo docker-compose up -d
```

View logs for errors.

To register new user(s):
  
access Docker shell:
```
sudo docker exec -it synapse bash
```
  
run the command and follow the on screen prompts:
```
register_new_matrix_user -c /data/homeserver.yaml http://localhost:8008
```
  
Type: `exit`, to leave the container's shell.
  
Use for the Reverse Proxy to handle incomming HTTPS connections and forward them to the correct Docker containers,
also to automatically fetch and renew Let's Encrypt certificates.

To allow anyone to register an account set 'enable_registration' to true in the homeserver.yaml.
This is NOT recomended. (?)
