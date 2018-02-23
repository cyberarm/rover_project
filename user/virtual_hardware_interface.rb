class VirtualHardwareInterface < RoverProject::HardwareInterface
  def setup
    add_motor_controller(name: :drivetrain, type: :L298N, pins: {enable_a: 3, in1: 5, in2: 7, in3: 8, in4: 10, enable_b: 12})
    add_motor(name: :left_drive, motor_controller: :drivetrain, direction: :forward, port: :a)
    add_motor(name: :right_drive, motor_controller: :drivetrain, direction: :backward, port: :b)

    add_input(name: :gamepad, type: :gamepad)
    add_input(name: :keyboard, type: :keyboard)
    add_input(name: :mouse, type: :mouse)
  end
end
