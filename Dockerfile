FROM elixir:1.11.2-alpine AS Elixir

RUN apk update
RUN apk add nodejs npm inotify-tools

RUN mkdir /opt/project_a
WORKDIR /opt/project_a

RUN mix local.hex --force
RUN mix archive.install hex phx_new 1.5.7
RUN mix local.rebar --force