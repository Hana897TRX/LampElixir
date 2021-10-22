defmodule BulbWeb.Statechart do
  use GenServer

  def start_link(ui), do: GenServer.start_link(__MODULE__, ui)

  def init(ui) do
    {:ok, %{ui_pid: ui, st: Off}}
  end

  def handle_cast(:switch, %{ui_pid: ui, st: Off} = state) do
    GenServer.cast(ui, :switch_on)
    {:noreply, %{state | st: On}}
  end

  def handle_cast(:switch, %{ui_pid: ui, st: On} = state) do
    GenServer.cast(ui, :switch_off)
    {:noreply, %{state | st: Off}}
  end

  def handle_cast(:alarm, %{ui_pid: ui, st: Off} = state) do
    GenServer.cast(ui, :switch_on)
    timer = Process.send_after(self(), :alarm_On_to_alarm_Off, 1000)
    {:noreply, %{state | st: AlarmOn}}
  end

  def handle_cast(:alarm, %{ui_pid: ui, st: AlarmOn} = state) do
    GenServer.cast(ui, :switch_off)
    {:noreply, %{state | st: Off}}
  end

  def handle_info(:alarm_On_to_alarm_Off, %{ui_pid: ui, st: AlarmOn} = state) do
    GenServer.cast(ui, :switch_off)
    {:noreply, %{state | st: AlarmOff}}
  end
end
