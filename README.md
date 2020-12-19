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

Setup the application with its dependencies
```
docker-compose run phoenix mix setup
```

### Elixir console
Run
```
docker-compose run phoenix iex -S mix
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