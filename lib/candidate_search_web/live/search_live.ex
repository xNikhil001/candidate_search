defmodule CandidateSearchWeb.SearchLive do
  use CandidateSearchWeb, :live_view
  alias CandidateSearch.Query.Candidates

  def mount(_params, _session, socket) do
    candidates = Candidates.get_all_candidates()

    socket =
      assign(socket,
        candidates: candidates,
        filter: %{"total_experience" => "", "qualifications" => [], "age" => ""}
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="text-zinc-100">
      <div class="">
        <form class="" phx-change="filter">
          <div class="">
            <h3 class="text-xl font-bold text-gray-300">Filter by qualification</h3>
            <div class="grid grid-cols-4 gap-4">
              <label :for={q <- qualifications_list()} class="text-gray-900 relative font-bold p-4">
                <input
                  type="checkbox"
                  value={q}
                  checked={q in @filter["qualifications"]}
                  name="qualifications[]"
                  class="bg-gray-300 px-10 py-4 outline-none border-none absolute z-[-1] rounded-[4px]"
                  phx-debounce="250"
                />
                <span class="absolute p-1">
                  <%= q %>
                </span>
              </label>
              <input type="hidden" type="checkbox" value="" checked="true" name="qualifications[]" />
            </div>
          </div>

          <div class="py-8">
            <label for="" class="flex flex-col">
              Filter by experience
              <input
                type="number"
                name="total_experience"
                value={@filter["total_experience"]}
                class="max-w-[300px] w-11/12 text-white text-xl bg-transparent my-2"
                placeholder="0"
                phx-debounce="250"
              />
            </label>
          </div>

          <div class="py-8">
            <label for="" class="flex flex-col">
              Filter by age
              <input
                type="number"
                name="age"
                value={@filter["age"]}
                class="max-w-[300px] w-11/12 text-white text-xl bg-transparent my-2"
                placeholder="0"
                phx-debounce="250"
              />
            </label>
          </div>
        </form>
      </div>

      <.table id="candidates" rows={@candidates}>
        <:col :let={candidate} label="Name"><%= candidate.name %></:col>
        <:col :let={candidate} label="Experience"><%= candidate.total_experience %></:col>
        <:col :let={candidate} label="Age"><%= calculate_age(candidate.birth_date) %> years</:col>
        <:col :let={candidate} label="Qualifications">
          <span
            :for={q <- candidate.qualifications}
            class="bg-gray-300 text-black p-1 m-1 text-sm rounded-md"
          >
            <%= q %>
          </span>
        </:col>
      </.table>
    </div>
    """
  end

  def handle_event("filter", params, socket) do
    %{"qualifications" => q, "total_experience" => exp, "age" => age} = params
    filter = %{"qualifications" => q, "total_experience" => exp, "age" => age}

    candidates = Candidates.get_by_filter(filter)

    {:noreply, assign(socket, candidates: candidates, filter: filter)}
  end

  def calculate_age(date) do
    {:ok, old_date} = Date.from_iso8601(Date.to_string(date))
    current_date = Date.utc_today()

    current_date.year - old_date.year
  end

  @spec qualifications_list() :: list(String.t())
  def qualifications_list() do
    [
      "SSC",
      "HSSC",
      "BA",
      "MA",
      "BE",
      "ME",
      "BBA",
      "MBA",
      "BCA",
      "MCA",
      "DIPLOMA",
      "BSC",
      "MSC",
      "PHD"
    ]
  end
end
