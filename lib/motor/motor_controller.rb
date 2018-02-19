module RoverProject
  class MotorController

    attr_reader :motors
    def initialize(name, type, max_motors, pins)
      @name = name
      @type = type
      @max_motors = max_motors
      @pins = pins

      @motors = []
    end
  end
end
