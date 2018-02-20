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
        @pins = @motor_controller.pins
      end

      def setup
        RPi::GPIO.set_numbering(:board)

        if @motor_controller.motors.count == 2
          @port_a_pwm = RPi::GPIO::PWM.new(@pins[:enable_a], 100)
          @port_a_pwm.start(0)
          RPi::GPIO.setup(@pins[:in1], as: :output)
          RPi::GPIO.setup(@pins[:in2], as: :output)
          @port_b_pwm = RPi::GPIO::PWM.new(@pins[:enable_b], 100)
          @port_b_pwm.start(0)
          RPi::GPIO.setup(@pins[:in3], as: :output)
          RPi::GPIO.setup(@pins[:in4], as: :output)
        else
          if @pins[:enable_a]
            @port_a_pwm = RPi::GPIO::PWM.new(@pins[:enable_a], 100)
            @port_a_pwm.start(0)
            RPi::GPIO.setup(@pins[:in1], as: :output)
            RPi::GPIO.setup(@pins[:in2], as: :output)
          elsif @pins[:enable_b]
            @port_b_pwm = RPi::GPIO::PWM.new(@pins[:enable_b], 100)
            @port_b_pwm.start(0)
            RPi::GPIO.setup(@pins[:in3], as: :output)
            RPi::GPIO.setup(@pins[:in4], as: :output)
          else
            raise "'#{@motor_controller.name}' has no PWM pin set for #{@motor_controller.type.to_s.upcase}"
          end
        end
      end

      def update
        @motor_controller.motors.each do |motor|
          if motor.speed.between?(-Motor::ZERO_FUZZ, Motor::ZERO_FUZZ)
            set_pins(motor, :stop)
          elsif motor.direction == Motor::FORWARD
            set_pins(motor, :forward)
          elsif motor.direction == Motor::BACKWARD
            set_pins(motor, :backward)
          end
        end
        # log("MotorController[L298N]", "Updated!")
      end

      def set_pins(motor, mode = :stop)
        pwm, forward, backward = nil, nil, nil
        if motor.port == :a
          pwm = @port_a_pwm
          forward = @pins[:in1]
          backward = @pins[:in2]
        elsif motor.port == :b
          pwm = @port_b_pwm
          forward = @pins[:in3]
          backward = @pins[:in4]
        end

        case mode
        when :stop
          pwm.duty_cycle = 0
          RPi::GPIO.set_low(forward)
          RPi::GPIO.set_low(backward)
        when :forward
          pwm.duty_cycle = motor.speed
          RPi::GPIO.set_high(forward)
          RPi::GPIO.set_low(backward)
        when :backward
          pwm.duty_cycle = motor.speed
          RPi::GPIO.set_low(forward)
          RPi::GPIO.set_high(backward)
        end
        # log("MotorController[L298N]", "Motor #{motor.port}: POWER: #{motor.power}, PWM: #{pwm.duty_cycle}, forward: #{RPi::GPIO.high?(forward)}, backward: #{RPi::GPIO.high?(backward)}")
      end
    end
  end
end
