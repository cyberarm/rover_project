require_relative "../rover_project"
require_relative "../user/virtual_hardware_interface"

class TeleOp < RoverProject::Program
  def setup
    use(VirtualHardwareInterface)
  end

  def loop
    if input(:gamepad) && input(:gamepad).ready
      motor(:left_rear_drive).set_power(input(:gamepad).left_stick_y)
      motor(:right_rear_drive).set_power(input(:gamepad).right_stick_y)

      motor(:left_front_drive).set_power(input(:gamepad).left_stick_y)
      motor(:right_front_drive).set_power(input(:gamepad).right_stick_y)
    end
  end

  def stop
    log("TeleOp", "Shutdown.")
  end
end

class YetAnotherProgram < TeleOp
end

RoverProject::Supervisor.new("0.0.0.0", 4567)
