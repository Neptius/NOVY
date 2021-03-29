defmodule NovySite.Presence do
  @moduledoc false

  use Phoenix.Presence,
    otp_app: :novy_site,
    pubsub_server: NovySite.PubSub
end
