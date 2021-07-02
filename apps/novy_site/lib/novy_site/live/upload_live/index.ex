defmodule NovySite.UploadLive.Index do
  @moduledoc false

  use NovySite, :live_view

  alias NovyData.S3Upload

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)

    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:avatar,
       accept: ~w(.png .jpeg .jpg .gif .mp4),
       max_entries: 3,
       external: &presign_upload/2
     )}
  end

  defp presign_upload(entry, socket) do
    IO.inspect("presign_upload")
    uploads = socket.assigns.uploads
    bucket = Application.fetch_env!(:novy_data, :aws_s3_bucket)
    key = "public/#{entry.client_name}"

    config = %{
      region: "eu-west-3",
      access_key_id: Application.fetch_env!(:novy_data, :aws_access_key_id),
      secret_access_key: Application.fetch_env!(:novy_data, :aws_secret_access_key)
    }

    {:ok, fields} =
      S3Upload.sign_form_upload(config, bucket,
        key: key,
        content_type: entry.client_type,
        max_file_size: uploads.avatar.max_file_size,
        expires_in: :timer.hours(1)
      )

    meta = %{
      uploader: "S3",
      key: key,
      url: "https://#{bucket}.s3-#{config.region}.amazonaws.com",
      fields: fields
    }

    {:ok, meta, socket}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    IO.inspect("validate")
    # * PROCESS DE VALIDATION
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    IO.inspect("save")
    # * SAUVEGARDE EN BASE DE DONNÉE

    # * CLEAR AVATAR
    consume_uploaded_entries(socket, :avatar, fn _meta, _entry -> :ok end)
    {:noreply, socket}
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    IO.inspect("cancel:#{ref}")
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end
end
