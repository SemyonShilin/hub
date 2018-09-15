defmodule Hub.MessageHandler.Supervisor do
  use Supervisor
  alias Hub.MessageHandler.{Producer, ProducerConsumer, Consumer}

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      {Producer, []},
      {ProducerConsumer, []},
      {Consumer, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end