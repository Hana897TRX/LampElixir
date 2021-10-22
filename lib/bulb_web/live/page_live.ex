defmodule BulbWeb.PageLive do
  use BulbWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, sc} = BulbWeb.Statechart.start_link(self())
    {:ok, assign(socket, lamp_is_on: false, statechart: sc)}
  end

  def handle_event("switch", _session, socket) do
    GenServer.cast(socket.assigns.statechart, :switch)
    {:noreply, socket}
  end

  def handle_event("alarm", _session, socket) do
    GenServer.cast(socket.assigns.statechart, :alarm)
    {:noreply, socket}
  end

  def handle_cast(:switch_on, socket) do
    {:noreply, assign(socket, lamp_is_on: true)}
  end

  def handle_cast(:switch_off, socket) do
    {:noreply, assign(socket, lamp_is_on: false)}
  end
end
