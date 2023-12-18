defmodule RiceCookerTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias RiceCooker.Core.Model.Rc

  test "Initial state" do
    rc = new_rice_cooker()
    assert !rc.is_lid_open
    assert !rc.is_plugged
    assert !rc.is_ready
  end

  test "open/close the lid" do
    rc = new_rice_cooker()
    assert !rc.is_lid_open
    updated_rc = Rc.set_is_lid_open(rc, true)
    assert updated_rc.is_lid_open
  end

  test "plug/unplug the rice cooker" do
    rc = new_rice_cooker()
    assert !rc.is_plugged
    updated_rc = Rc.set_is_plugged(rc, true)
    assert updated_rc.is_plugged
  end

  test "put rice/water cup when the inner pot is opened" do
    rc = new_rice_cooker()

    assert capture_io(fn -> Rc.add_rice_cup(rc, 2) end) ==
             "[INFO]: Consider opening the lid of the inner pot first\n"

    assert capture_io(fn -> Rc.add_water_cup(rc, 2) end) ==
             "[INFO]: Consider opening the lid of the inner pot first\n"

    opened_lid_rc = Rc.set_is_lid_open(rc, true)
    # ok
    assert capture_io(fn -> Rc.add_rice_cup(opened_lid_rc, 2) end) == ""
  end

  test "cook when everything is ok and get ready-to-serve food" do
    rc = new_ready_rice_cooker()

    assert capture_io(fn -> rc |> Rc.set_is_plugged(false) |> Rc.cook() end) ==
             "[INFO]: Plug the rice cooker to start cooking\n"

    empty_rc = %Rc{rc | water_cup: 0, rice_cup: 0}

    assert capture_io(fn -> Rc.cook(empty_rc) end) ==
             "[WARNING]: Inner pot must contains rice and water before starting to cook\n"

    ready_rc = Rc.cook(rc)
    assert ready_rc.is_ready

    served_rc =
      ready_rc
      |> Rc.set_is_plugged(false)
      |> Rc.set_is_lid_open(true)
      |> Rc.get_ready_to_serve_food()

    assert served_rc.water_cup == 0 and served_rc.rice_cup == 0
  end

  defp new_rice_cooker(), do: %Rc{}

  defp new_ready_rice_cooker() do
    new_rice_cooker()
    |> Rc.set_is_lid_open(true)
    |> Rc.add_rice_cup(2)
    |> Rc.add_water_cup(1)
    |> Rc.set_is_lid_open(false)
    |> Rc.set_is_plugged(true)
  end
end
