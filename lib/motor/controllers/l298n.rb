module RoverProject
  class MotorController
    class L298N

      attr_reader :max_motors, :max_pins, :motor_controller
      def initialize(motor_controller)
        @motor_controller = motor_controller
        @max_motors = 2
        @max_pins   = 6
        @port_a = 0
        @port_b = 1
      end

      def update
        # Do GPIO stuff
        @motor_controller.motors.each_with_index do |motor, port|
          p port
          if motor.speed.between?(-Motor::ZERO_FUZZ, Motor::ZERO_FUZZ)
            # pwm 0/off
            # pin1 low
            # pin2 low
          elsif motor.direction == Motor::FORWARD
            # pwm speed
            # pin1 high
            # pin2 low
          elsif motor.direction == Motor::BACKWARD
            # pwm speed
            # pin1 low
            # pin2 high
          end
        end
        log("MotorController[L298N]", "Updated!")
      end
    end
  end
end
