defmodule NovySite.UploadLive.Index do
  @moduledoc false

  use NovySite, :live_view

  alias NovyData.S3Upload.


  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:avatar, accept: :any, max_entries: 3, external: &presign_upload/2)}
  end

  defp presign_upload(entry, socket) do
    uploads = socket.assigns.uploads
    bucket = "novy-s3-upload"
    key = "public/#{entry.client_name}"

    config = %{
      region: "eu-west-3",
      access_key_id: Application.get_env(:novy_site, :access_key_id),
      secret_access_key: Application.get_env(:novy_site, :secret_access_key),
    }

    {:ok, fields} =
      S3Upload.sign_form_upload(config, bucket,
        key: key,
        content_type: entry.client_type,
        max_file_size: uploads.avatar.max_file_size,
        expires_in: :timer.hours(1)
      )

    meta = %{uploader: "S3", key: key, url: "http://#{bucket}.s3.amazonaws.com", fields: fields}
    {:ok, meta, socket}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end
end
