# Matrix
An open network for secure, decentralized communication
  
---
  
Example for: element-config.json  - (https://develop.element.io/config.json)

#Remove "default_server_name": "matrix.org" from element-config.json as this is deprecated and add custom homeserver to the top of element-config.json:
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

#Generate Synapse Config:
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
#Deploy
```
sudo docker-compose up -d
```

#View logs

#Access docker shell:
```
sudo docker exec -it synapse bash
```

#Follow the on screen prompts to register new user(s)
```
register_new_matrix_user -c /data/homeserver.yaml http://localhost:8008
```

#Enter: `exit`, to leave the container's shell.

Edit `synapse/homeserver.yaml`:

#Comment out sqlite database (replaced with postgres)
```
#database:
#  name: sqlite3
#  args:
#    database: /data/homeserver.db
```

# Uncoment: 
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

#Other important settings, uncomment/edit:
```
server_name: "matrix.example.com"
web_client_location: https://<subdomain-for-element-web>.example.com
public_baseurl: https://matrix.example.com/
serve_server_wellknown: true
presence:
  enabled: true
```

#Use for the reverse proxy to handle incomming HTTPS connections and forward them to the correct docker containers and to automatically fetch and renew Let's Encrypt certificates.

#To allow anyone to register an account set 'enable_registration' to true in the homeserver.yaml.
#This is NOT recomended. (?)
