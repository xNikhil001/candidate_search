defmodule CandidateSearchWeb.CandidateController do
  use CandidateSearchWeb, :controller
  alias CandidateSearch.Query.Candidates

  def index(conn, params) do
    candidates_list = Candidates.get_by_filter(params)

    {:ok, data} = Jason.encode(candidates_list)

    conn
    |> put_resp_header("Content-Type", "application/json")
    |> send_resp(200, data)
  end

  def update(conn, %{"id" => id} = params) do
    user_data = Map.drop(params, ["id"])

    case Candidates.update_candidate(id, user_data) do
      {:error, msg} ->
        {:ok, data} = Jason.encode(msg)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, data)

      {:success, msg} ->
        {:ok, data} = Jason.encode(msg)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, data)
    end
  end

  def delete(conn, %{"id" => id} = _params) do
    case Candidates.delete_candidate(id) do
      {:error, msg} ->
        {:ok, data} = Jason.encode(msg)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, data)

      {:success, msg} ->
        {:ok, data} = Jason.encode(msg)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, data)
    end
  end
end
