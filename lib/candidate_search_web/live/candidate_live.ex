defmodule CandidateSearchWeb.CandidateLive do
  @moduledoc """
  Used to create Candidate
  """
  use CandidateSearchWeb, :live_view
  alias CandidateSearch.Query.Candidates
  alias CandidateSearch.Candidates.Candidate

  def mount(_params, _session, socket) do
    # fetch the initial changeset
    changeset = Candidates.change_candidate(%Candidate{})
    socket = assign(socket, form: to_form(changeset))
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.form for={@form} class="" phx-submit="save">
      <div class="py-4">
        <.label>Enter your name</.label>
        <.input type="text" field={@form[:name]} placeholder="John Doe" />
      </div>

      <div class="py-4">
        <.label>Select Qualifications</.label>
        <.input
          type="select"
          multiple={true}
          field={@form[:qualifications]}
          options={qualifications_list()}
        />
      </div>

      <div class="py-4">
        <.label>Select your date of birth</.label>
        <.input type="date" field={@form[:birth_date]} />
      </div>

      <div class="py-4">
        <.label>Enter your total experience</.label>
        <.input field={@form[:total_experience]} type="number" placeholder="1" />
      </div>

      <.button class="w-[160px] mt-8">Submit</.button>
    </.form>
    """
  end

  def handle_event("save", %{"candidate" => candidate}, socket) do
    case Candidates.create_candidate(candidate) do
      {:ok, _} ->
        socket = put_flash(socket, :info, "Candidate added successfully")
        changeset = Candidates.change_candidate(%Candidate{})
        socket = assign(socket, form: to_form(changeset))
        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, form: to_form(changeset))
        {:noreply, socket}
    end
  end

  @doc """
  Returns Key-Value List for options html tag
  """
  @spec qualifications_list() :: list({atom(), String.t()})
  def qualifications_list() do
    [
      SSC: "SSC",
      HSSC: "HSSC",
      BA: "BA",
      MA: "MA",
      BE: "BE",
      ME: "ME",
      BBA: "BBA",
      MBA: "MBA",
      BCA: "BCA",
      MCA: "MCA",
      DIPLOMA: "DIPLOMA",
      BSC: "BSC",
      MSC: "MSC",
      PHD: "PHD"
    ]
  end
end
