defmodule Hub.Queue.Supervisor do
  use Supervisor
  alias Hub.Queue.{Consumer, Producer}

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      {Producer, []},
      {Consumer, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end