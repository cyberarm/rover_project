module RoverProject
  class HardwareInterface

    attr_reader :motor_controllers, :motors, :inputs
    def initialize
      SDL2.init(SDL2::INIT_EVERYTHING)

      @motor_controllers = {}
      @motors = {}
      @inputs = {}

      setup
      setup_controllers
    end

    def setup
    end

    def setup_controllers
      @motor_controllers.each {|k, controller| controller.setup}
    end

    # @param name [Symbol] Name of controller e.g. :drivetrain
    # @param type [Symbol] type of motor controller, currently assumes :L298N?
    # @param pins [Hash] Pins that the motor controller uses e.g. enable_a: 0, int1: 1, int2: 2, int3: 3, int4: 4, enable_b: 5
    def add_motor_controller(name:, type:, pins:)
      raise "Motor Controller name '#{name}' already in use!" if @motor_controllers[name]
      @motor_controllers[name] = MotorController.new(name, type, pins)
    end

    # @param name [Symbol] name of motor e.g. :left_drive
    # @param motor_controller [Symbol] Name of motor controller this motor is attached to e.g. :drivetrain
    # @param port [Symbol] port this motor uses on the controller e.g. :a
    def add_motor(name:, motor_controller:, direction:, port:)
      raise "Motor name '#{name}' already in use!" if @motors[name]
      motor = Motor.new(name, port, 0, direction)
      @motor_controllers[motor_controller].add_motor(motor)
      @motors[name] = motor
    end

    # @param name [Symbol] Name of input e.g. :gamepad
    # @param type [Symbol] Type of input e.g. :gamepad. :gampad, :keyboard, and :mouse are supported
    # @param options [Hash] Optional hash to pass to input
    def add_input(name:, type:, options: {})
      raise "Input name '#{name}' already in use!" if @inputs[name]
      case type
      when :gamepad
        @inputs[name] = Input::GamePad.new(options)
      when :keyboard
        @inputs[name] = Input::Keyboard.new(options)
      when :mouse
        @inputs[name] = Input::Mouse.new(options)
      else
        raise "Unknown input type '#{type}'"
      end
    end

    def update_controllers
      @motor_controllers.each do |k, controller|
        controller.update
      end
    end

    def reset_buttons
      @inputs.each do |k, klass|
        klass.keys.each do |key, value|
          key = nil if value == :released
        end
      end
    end
  end
end
