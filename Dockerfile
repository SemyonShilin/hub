FROM elixir:1.6.4

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -y inotify-tools build-essential postgresql-client nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN mix local.hex --force && mix local.rebar --force
RUN mix archive.install --force  https://github.com/phoenixframework/archives/raw/master/phx_new-1.3.3.ez

RUN mkdir -p /usr/src/app
COPY . /usr/src/app

WORKDIR /usr/src/app

RUN mix deps.get && mix deps.compile
RUN cd assets && npm install
RUN cd /usr/src/app
