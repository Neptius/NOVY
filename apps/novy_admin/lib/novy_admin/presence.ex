defmodule NovyAdmin.Presence do
  @moduledoc false

  use Phoenix.Presence,
    otp_app: :novy_admin,
    pubsub_server: NovyAdmin.PubSub
end
