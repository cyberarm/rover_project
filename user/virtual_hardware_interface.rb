class VirtualHardwareInterface < RoverProject::HardwareInterface
  def setup
    add_motor_controller(:drivetrain, :L298N, 2, {enable_a: 0, int1: 1, int2: 2, int3: 3, int4: 4, enable_b: 5})
    add_motor(:left_drive, :drivetrain, RoverProject::Motor::FORWARD,  :a)
    add_motor(:right_drive,:drivetrain, RoverProject::Motor::BACKWARD, :b)
    # add_input(:gamepad, RoverProject::Input::GamePad.new)
    add_input(:keyboard, RoverProject::Input::Keyboard.new)
    add_input(:mouse, RoverProject::Input::Mouse.new)
  end
end
