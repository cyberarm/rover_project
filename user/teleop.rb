require_relative "../rover_project"
require_relative "../user/virtual_hardware_interface"

class TeleOp < RoverProject::Program
  def setup
    use(VirtualHardwareInterface)
    add_input(:gamepad, GamePad.new)
  end

  def loop
    if input(:gamepad).left_bumper
      puts "LEFT BUMPER"
    end
  end

  def stop
    puts "Shutdown."
  end
end

RoverProject::Supervisor.new("0.0.0.0", 4567)
