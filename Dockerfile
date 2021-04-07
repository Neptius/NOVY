FROM elixir:1.11.4-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base git python3 yarn npm
RUN npm install -g pnpm

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
RUN pnpm --prefix ./assets install --prod --frozen-lockfile
RUN pnpm run --prefix ./assets deploy
# RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error
# RUN npm run --prefix ./assets deploy
# RUN yarn --cwd ./assets install --frozen-lockfile
# RUN yarn --cwd ./assets deploy
RUN mix phx.digest

WORKDIR /app
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

########################################################################

# prepare release image
# FROM alpine AS app
FROM nginx:alpine AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/novy ./
COPY --from=build --chown=nobody:nobody /app/entrypoint.sh ./

ENV HOME=/app

COPY nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]
