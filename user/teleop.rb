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

class Autonomous < TeleOp
  def loop
    motor(:left_rear_drive).set_power(255)
    motor(:right_rear_drive).set_power(255)

    motor(:left_front_drive).set_power(255)
    motor(:right_front_drive).set_power(255)

    delay(1)

    motor(:left_rear_drive).set_power(0)
    motor(:right_rear_drive).set_power(0)

    motor(:left_front_drive).set_power(0)
    motor(:right_front_drive).set_power(0)

    delay(1)

    motor(:left_rear_drive).set_power(255)
    motor(:right_rear_drive).set_power(255)

    motor(:left_front_drive).set_power(255)
    motor(:right_front_drive).set_power(255)

    delay(1)

    motor(:left_rear_drive).set_power(0)
    motor(:right_rear_drive).set_power(0)

    motor(:left_front_drive).set_power(0)
    motor(:right_front_drive).set_power(0)
  end

  def stop
    log("Autonomous", "Shutdown.")
  end
end

RoverProject::Supervisor.new("0.0.0.0", 4567)
