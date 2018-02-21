# Rover Project
An over ambitious project to create a robot control system.
## Example*
* This is the goal and does not function as such yet.

``` ruby
require "rover_project"

# Define hardware and input
class VirtualHardwareInterface < RoverProject::HardwareInterface
  def setup
    add_motor_controller(name: :drivetrain, type: :L298N, pins: {enable_a: 0, in1: 1, in2: 2, in3: 3, in4: 4, enable_b: 5})
    add_motor(name: :left_drive, motor_controller: :drivetrain, direction: :forward, port: :a)
    add_motor(name: :right_drive, motor_controller: :drivetrain, direction: :backward, port: :b)

    add_input(name: :gamepad, type: :gamepad)
  end
end

# Program to run
class TeleOp < RoverProject::Program
  def setup
    use(VirtualHardwareInterface)
  end

  def loop
    motor(:left_drive).set_power(input(:gamepad).left_stick_y)
    motor(:right_drive).set_power(input(:gamepad).right_stick_y)
  end
end

# # Start Rover supervisor which manages the main loop
RoverProject::Supervisor.new("0.0.0.0", 4567)
```
