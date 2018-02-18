module RoverProject
  class Motor
    BACKWARD = 0
    FORWARD  = 1

    attr_reader :name

    def initialize(initial_name, initial_power = 0, initial_direction = FORWARD)
      set_name(initial_name)
      set_power(initial_power)
      set_direction(initial_direction)
    end

    def name
      @name
    end

    def set_name(symbol)
      raise "Name must be a symbol" unless symbol.is_a?(Symbol)
      @name = symbol
    end

    def power
      @power
    end

    # A power is a integer between 0 to 100
    def set_power(integer)
      raise "power must be a whole number (Integer)" unless integer.is_a?(Integer)
      @power = integer
    end

    def direction
      @direction
    end

    # Direction is either 1 or 0.
    # 0 for BACKWARD and 1 for FORWARD
    def set_direction(integer)
      raise "Direction must 1 or 0" unless integer.is_a?(Integer) && (integer == FORWARD || integer == BACKWARD)
      @direction = integer
    end
  end
end
