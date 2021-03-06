defmodule BulbWeb.Statechart do
  use GenServer

  def start_link(ui), do: GenServer.start_link(__MODULE__, ui)

  def init(ui) do
    {:ok, %{ui_pid: ui, st: Off}}
  end

  def handle_cast(:switch, %{ui_pid: ui, st: down} = state) do
    if(state[:st] == Off) do
      GenServer.cast(ui, :switch_on)
      {:noreply, %{state | st: On}}
    else
      GenServer.cast(ui, :switch_off)
      {:noreply, %{state | st: Off}}
    end
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
    timer = Process.send_after(self(), :alarm_Off_to_alarm_On, 1000)
    GenServer.cast(ui, :switch_off)
    {:noreply, %{state | st: AlarmOff}}
  end

  def handle_info(:alarm_Off_to_alarm_On, %{ui_pid: ui, st: AlarmOff} = state) do
    timer = Process.send_after(self(), :alarm_On_to_alarm_Off, 1000)
    GenServer.cast(ui, :switch_on)
    {:noreply, %{state | st: AlarmOn}}
  end
end
