defmodule Ebay do
  use Application

  def start(_type, _args) do
    children = [
      {Ebay.Repo, []},
      {Scheduler, [Scheduler]},
      {Ebay.AuctionServer, [Ebay.AuctionServer]}
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
