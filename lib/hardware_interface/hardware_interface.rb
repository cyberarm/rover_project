module RoverProject
  class HardwareInterface
    def initialize
      setup
    end

    def setup
    end

    # @param name [Symbol] Name of controller e.g. :drivetrain
    # @param type [Symbol] type of motor controller, currently assumes :L298N?
    # @param max_motors [Integer] Number of motors that this controller supports e.g. 2
    # @param pins [Hash] Pins that the motor controller uses e.g. enable_a: 0, int1: 1, int2: 2, int3: 3, int4: 4, enable_b: 5
    def add_motor_controller(name, type, max_motors, pins)
    end

    # @param name [Symbol] name of motor e.g. :left_drive
    # @param port [Symbol] port this motor uses on the controller e.g. :a
    # @param motor_controller [Symbol] Name of motor controller this motor is attached to e.g. :drivetrain
    def add_motor(name, port, motor_controller)
    end

    # @param name [Symbol] Name of input e.g. :gamepad
    # @param klass [GamePad,Keyboard,Mouse] Instance of an input class e.g. GamePad.new
    def add_input(name, klass)
    end
  end
end
