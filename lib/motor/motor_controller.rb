module RoverProject
  class MotorController

    attr_reader :name, :type, :pins, :controller, :motors
    def initialize(name, type, pins)
      @name = name
      @type = type
      @pins = pins
      @controller = Object.const_get("RoverProject::MotorController::#{type.to_s.upcase}").new(self)
      raise "Too many pins (#{@pins.count}) for '#{self.name}', controller (#{@type.to_s.upcase}) only supports #{@controller.max_pins}" if @pins.count > @controller.max_pins
      @motors = []
    end

    # Calls setup on the actual motor controller
    def setup
      @controller.setup
    end

    # Calls update on the actual motor controller
    def update
      @controller.update
    end

    # Calls teardown on the actual motor controller
    def teardown
      @controller.teardown
    end

    # Adds motor to controller
    # @param motor [Motor] Instance of motor
    def add_motor(motor)
      if @motors.count >= @controller.max_motors
        raise "To many motors for controller '#{@name}' (#{@type.to_s.upcase})"
      end
      if @motors.detect {|m| m.port == motor.port}
        raise "Port '#{motor.port}' already in use by '#{@motors.detect {|m| m.port == motor.port}.name}'"
      end
      if @motors.detect {|m| m.name == motor.name}
        raise "Name '#{motor.name}' already in use on controller '#{self.name}' (Also, this error should be impossible to reach!)"
      end
      @motors << motor
    end
  end
end
