class VirtualHardwareInterface < RoverProject::HardwareInterface
  def setup
    add_motor_controller()
  end
end
