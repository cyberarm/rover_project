require_relative "../rover_project"
require_relative "../user/virtual_hardware_interface"

class TeleOp < RoverProject::Program
  def setup
    use(VirtualHardwareInterface)
    # sound("/home/cyberarm/Downloads/25032__sirplus__extreme-alarm.wav")
    speak "Setup Completed."
  end

  def loop
    if input(:gamepad) && input(:gamepad).ready
      if input(:gamepad).right_bumper
        motor(:left_rear_drive).set_power(input(:gamepad).left_stick_y)
        motor(:right_front_drive).set_power(-input(:gamepad).left_stick_y)

        motor(:right_rear_drive).set_power(-input(:gamepad).right_stick_y)
        motor(:left_front_drive).set_power(input(:gamepad).right_stick_y)
      elsif input(:gamepad).left_bumper
        motor(:left_rear_drive).set_power(input(:gamepad).left_stick_y)
        motor(:right_rear_drive).set_power(input(:gamepad).left_stick_y)

        motor(:left_front_drive).set_power(input(:gamepad).right_stick_y)
        motor(:right_front_drive).set_power(input(:gamepad).right_stick_y)
      else
        motor(:left_rear_drive).set_power(input(:gamepad).left_stick_y)
        motor(:right_rear_drive).set_power(input(:gamepad).right_stick_y)

        motor(:left_front_drive).set_power(input(:gamepad).left_stick_y)
        motor(:right_front_drive).set_power(input(:gamepad).right_stick_y)
      end
    end
  end

  def stop
    log("Shutdown.")
  end
end

class Autonomous < TeleOp
  def loop
    motor(:left_rear_drive).set_power(255)
    motor(:right_rear_drive).set_power(255)

    motor(:left_front_drive).set_power(255)
    motor(:right_front_drive).set_power(255)

    log("Forward")
    delay(1)

    motor(:left_rear_drive).set_power(0)
    motor(:right_rear_drive).set_power(0)

    motor(:left_front_drive).set_power(0)
    motor(:right_front_drive).set_power(0)

    log("Still")
    delay(1)

    motor(:left_rear_drive).set_power(-255)
    motor(:right_rear_drive).set_power(-255)

    motor(:left_front_drive).set_power(-255)
    motor(:right_front_drive).set_power(-255)

    log("Reverse")
    delay(1)

    motor(:left_rear_drive).set_power(0)
    motor(:right_rear_drive).set_power(0)

    motor(:left_front_drive).set_power(0)
    motor(:right_front_drive).set_power(0)

    log("Still")
    delay(1)
  end

  def stop
    log("Shutdown.")
  end
end

RoverProject::Supervisor.new("0.0.0.0", 4567)
