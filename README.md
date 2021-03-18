# Novy

## Setup Project

```zsh
# Setup Project
mix setup

# Gen cert novy_api
cd apps/novy_api
mix phx.gen.cert

# Gen cert novy_site
cd apps/novy_site
mix phx.gen.cert

# Gen cert novy_admin
cd apps/novy_admin
mix phx.gen.cert

# Start Phoenix
mix phx.server
```