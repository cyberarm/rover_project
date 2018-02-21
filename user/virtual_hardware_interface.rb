class VirtualHardwareInterface < RoverProject::HardwareInterface
  def setup
    add_motor_controller(name: :drivetrain, type: :L298N, pins: {enable_a: 0, in1: 1, in2: 2, in3: 3, in4: 4, enable_b: 5})
    add_motor(name: :left_drive, motor_controller: :drivetrain, direction: :forward, port: :a)
    add_motor(name: :right_drive, motor_controller: :drivetrain, direction: :backward, port: :b)

    # add_input(name: :gamepad, type: :gamepad)
    add_input(name: :keyboard, type: :keyboard)
    add_input(name: :mouse, type: :mouse)
  end
end
