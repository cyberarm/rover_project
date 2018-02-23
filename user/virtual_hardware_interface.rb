class VirtualHardwareInterface < RoverProject::HardwareInterface
  def setup
    add_motor_controller(name: :rear_drive, type: :L298N, pins: {enable_a: 3, in1: 5, in2: 7, in3: 8, in4: 10, enable_b: 12})
    add_motor(name: :left_rear_drive, motor_controller: :rear_drive, direction: :backward, port: :a)
    add_motor(name: :right_rear_drive, motor_controller: :rear_drive, direction: :forward, port: :b)

    add_motor_controller(name: :front_drive, type: :L298N, pins: {enable_a: 11, in1: 13, in2: 15, in3: 19, in4: 21, enable_b: 23})
    add_motor(name: :left_front_drive, motor_controller: :front_drive, direction: :backward, port: :a)
    add_motor(name: :right_front_drive, motor_controller: :front_drive, direction: :forward, port: :b)

    add_input(name: :gamepad, type: :gamepad)
    add_input(name: :keyboard, type: :keyboard)
    add_input(name: :mouse, type: :mouse)
  end
end
