# Rover Project
An over ambitious project to create a robot control system.
## Example*
* This is the goal and does not function as such yet.

``` ruby
class VirtualHardwareInterface < RoverProject::HardwareInterface
  def setup
    add_motor_controller(:drivetrain, :L298N, 2, {enable_a: 0, int1: 1, int2: 2, int3: 3, int4: 4, enable_b: 5})
    add_motor(:left_drive, :a)
    add_motor(:right_drive, :b)
    add_input(:gamepad, Input::GamePad.new)
  end
end

class TeleOp < RoverProject::Program
  def setup
    use(VirtualHardwareInterface)
  end

  def loop
    motor(:left_drive).set_power(input(:gamepad).left_stick_y)
    motor(:right_drive).set_power(input(:gamepad).right_stick_y)
  end
end
```
