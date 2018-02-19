class VirtualHardwareInterface < RoverProject::HardwareInterface
  def setup
    add_motor_controller(name: :drivetrain, type: :L298N, pins: {enable_a: 0, int1: 1, int2: 2, int3: 3, int4: 4, enable_b: 5})
    add_motor(name: :left_drive, motor_controller: :drivetrain, direction: RoverProject::Motor::FORWARD, port: :a)
    add_motor(name: :right_drive, motor_controller: :drivetrain, direction: RoverProject::Motor::BACKWARD, port: :b)

    add_input(name: :gamepad, klass: RoverProject::Input::GamePad.new)
    add_input(name: :keyboard, klass: RoverProject::Input::Keyboard.new)
    add_input(name: :mouse, klass: RoverProject::Input::Mouse.new)
  end
end
