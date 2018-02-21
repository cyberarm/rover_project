require_relative "../rover_project"
require_relative "../user/virtual_hardware_interface"

class TeleOp < RoverProject::Program
  def setup
    use(VirtualHardwareInterface)
  end

  def loop
    if input(:gamepad)
      motor(:left_drive).set_power(input(:gamepad).left_stick_y)
      motor(:right_drive).set_power(input(:gamepad).right_stick_y)
      # log("GAMEPAD", "left Y: #{input(:gamepad).left_stick_y}, right Y: #{input(:gamepad).right_stick_y}")

      # puts "Axis leftX: #{input(:gamepad).left_stick_x}"
      # puts "Axis leftY: #{input(:gamepad).left_stick_y}"
      # puts "Axis rightX: #{input(:gamepad).right_stick_x}"
      # puts "Axis rightY: #{input(:gamepad).right_stick_y}"
      # puts "Axis leftTrigger: #{input(:gamepad).left_trigger}"
      # puts "Axis rightTrigger: #{input(:gamepad).right_trigger}"
      # puts "Last loop time: #{last_loop_time}s"
    end

    if input(:keyboard) && (!input(:gamepad).ready)
      if input(:keyboard).holding?("W")
        motor(:left_drive).set_power(200)
        motor(:right_drive).set_power(200)
      elsif input(:keyboard).holding?("S")
        motor(:left_drive).set_power(-200)
        motor(:right_drive).set_power(-200)
      elsif input(:keyboard).holding?("A")
        motor(:left_drive).set_power(-200)
        motor(:right_drive).set_power(200)
      elsif input(:keyboard).holding?("D")
        motor(:left_drive).set_power(200)
        motor(:right_drive).set_power(-200)
      else
        motor(:left_drive).set_power(0)
        motor(:right_drive).set_power(0)
      end
    end

    if input(:keyboard) && input(:keyboard).holding?("W")
      # puts "W is pressed."
    end
    if input(:keyboard) && input(:keyboard).released?("Tab")
      puts "Tab is released."
    end
    if input(:keyboard) && input(:keyboard).released?("W")
      puts "W is released."
    end

    if input(:mouse)
      if input(:mouse).released?(RoverProject::Input::Mouse::LEFT_BUTTON)
        puts "Left Mouse is released."
      end
      # puts "Mouse X: #{input(:mouse).x}, Y: #{input(:mouse).y}"
    end
  end

  def stop
    log("TeleOp", "Shutdown.")
  end
end

RoverProject::Supervisor.new("0.0.0.0", 4567)
