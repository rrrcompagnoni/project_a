# Project A
## Development setup
### Requirements

- Docker version 19.03.13
- docker-compose version 1.27.4

### Building

Build the container
```
docker-compose build
```

Start the database
```
docker-compose up -d db
```

Run the container console
```
docker-compose run phoenix /bin/sh
```

Fetch dependencies, compile assets, and setup the database
```
mix deps.get && mix ecto.setup && cd assets && npm install && node node_modules/webpack/bin/webpack.js --mode development && exit
```

### Web server
Run
```
docker-compose up
```
It will be available on `http://localhost:4000`

### Testing
Run
```
docker-compose run phoenix mix test
```