require_relative "../rover_project"
require_relative "../user/virtual_hardware_interface"

class TeleOp < RoverProject::Program
  def setup
    use(VirtualHardwareInterface)
  end

  def loop
    if input(:gamepad) && input(:gamepad).left_bumper
      puts "LEFT BUMPER"
    end
  end

  def stop
    log("TeleOp", "Shutdown.")
  end
end

RoverProject::Supervisor.new("0.0.0.0", 4567)
