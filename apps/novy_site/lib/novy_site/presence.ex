defmodule NovySite.Presence do
  use Phoenix.Presence,
    otp_app: :novy_site,
    pubsub_server: NovySite.PubSub
end
