# Je ne me sers plus de ce dockerfile
# Au moment ou je commit ce si, le ficher est utilisable
# mais ne le sera certainement plus à l'avenir

FROM elixir:1.11.3-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base git python2 yarn

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY config/ /app/config/
COPY mix.exs /app/
COPY mix.* /app/

COPY apps/novy_data/mix.exs /app/apps/novy_data/
COPY apps/novy_api/mix.exs /app/apps/novy_api/
COPY apps/novy_site/mix.exs /app/apps/novy_site/
COPY apps/novy_admin/mix.exs /app/apps/novy_admin/

RUN mix do deps.get, deps.compile

COPY . /app/

# build assets
WORKDIR /app/apps/novy_site
# RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error
# RUN npm run --prefix ./assets deploy
RUN yarn --cwd ./assets install --frozen-lockfile
RUN yarn --cwd ./assets deploy
RUN mix phx.digest

WORKDIR /app/apps/novy_admin
# RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error
# RUN npm run --prefix ./assets deploy
RUN yarn --cwd ./assets install --frozen-lockfile
RUN yarn --cwd ./assets deploy
RUN mix phx.digest

WORKDIR /app
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

########################################################################

# prepare release image
FROM nginx:alpine AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/novy ./
COPY --from=build --chown=nobody:nobody /app/entrypoint.sh ./

ENV HOME=/app

EXPOSE 8080

# COPY start.sh /docker-entrypoint.d/30-start.sh

COPY nginx/nginx.conf /etc/nginx/nginx.conf
# COPY nginx/templates/default.conf.template /etc/nginx/templates/default.conf.template
# CMD nginx -g "daemon on;" && /app/bin/novy eval "NovyData.Release.migrate" && /app/bin/novy start
ENTRYPOINT ["./entrypoint.sh"]
