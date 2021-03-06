module RoverProject
  class MotorController
    class L298N
      include Logger

      attr_reader :max_motors, :max_pins, :motor_controller
      def initialize(motor_controller)
        @motor_controller = motor_controller
        @max_motors = 2
        @max_pins   = 6
        @port_a = 0
        @port_b = 1
        @pins = @motor_controller.pins
        @pwm_freq = 100
      end

      # Sets up motor controller by setting GPIO pins
      def setup
        RPi::GPIO.set_numbering(:board)

        if @motor_controller.motors.count == 2
          RPi::GPIO.setup(@pins[:enable_a], as: :output)
          @port_a_pwm = RPi::GPIO::PWM.new(@pins[:enable_a], @pwm_freq)
          @port_a_pwm.start(0)
          RPi::GPIO.setup(@pins[:in1], as: :output)
          RPi::GPIO.setup(@pins[:in2], as: :output)
          RPi::GPIO.setup(@pins[:enable_b], as: :output)
          @port_b_pwm = RPi::GPIO::PWM.new(@pins[:enable_b], @pwm_freq)
          @port_b_pwm.start(0)
          RPi::GPIO.setup(@pins[:in3], as: :output)
          RPi::GPIO.setup(@pins[:in4], as: :output)
        else
          if @pins[:enable_a]
            RPi::GPIO.setup(@pins[:enable_a], as: :output)
            @port_a_pwm = RPi::GPIO::PWM.new(@pins[:enable_a], @pwm_freq)
            @port_a_pwm.start(0)
            RPi::GPIO.setup(@pins[:in1], as: :output)
            RPi::GPIO.setup(@pins[:in2], as: :output)
          elsif @pins[:enable_b]
            RPi::GPIO.setup(@pins[:enable_b], as: :output)
            @port_b_pwm = RPi::GPIO::PWM.new(@pins[:enable_b], @pwm_freq)
            @port_b_pwm.start(0)
            RPi::GPIO.setup(@pins[:in3], as: :output)
            RPi::GPIO.setup(@pins[:in4], as: :output)
          else
            raise "'#{@motor_controller.name}' has no PWM pin set for #{@motor_controller.type.to_s.upcase}"
          end
        end
      end

      # Updates motors
      def update
        @motor_controller.motors.each do |motor|
          if motor.speed.between?(-Motor::ZERO_FUZZ, Motor::ZERO_FUZZ)
            set_pins(motor, :stop)
          elsif motor.direction == :forward
            set_pins(motor, :forward)
          elsif motor.direction == :backward
            set_pins(motor, :backward)
          end
        end
      end

      # Stops motors are cleans up pins
      def teardown
        @port_a_pwm.stop if @port_a_pwm
        @port_b_pwm.stop if @port_b_pwm
        RPi::GPIO.clean_up(@pins[:in1])
        RPi::GPIO.clean_up(@pins[:in2])
        RPi::GPIO.clean_up(@pins[:in3])
        RPi::GPIO.clean_up(@pins[:in4])
      end

      # Sets the pins for the motor controller
      # @param motor [Motor]
      # @param mode [Symbol]
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
          pwm.duty_cycle = motor.pwm_speed
          RPi::GPIO.set_high(forward)
          RPi::GPIO.set_low(backward)
        when :backward
          pwm.duty_cycle = motor.pwm_speed
          RPi::GPIO.set_low(forward)
          RPi::GPIO.set_high(backward)
        end
        # log("Motor #{motor.port}: POWER: #{motor.power}, PWM: #{pwm.duty_cycle}, forward: #{RPi::GPIO.high?(forward)}, backward: #{RPi::GPIO.high?(backward)}")
      end
    end
  end
end
