defmodule Ebay do
  use Application
  import Scheduler
  import Ebay.AuctionServer

  def start(_type, _args) do
    children = [
      {Scheduler, [Scheduler]},
      {Ebay.AuctionServer, [Ebay.AuctionServer]},
      {Ebay.Repo, []}
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
