defmodule NovyApi.DefaultView do
  use NovyApi, :view

  def render("api-data.json", %{data: data}) do
    data
  end
end
