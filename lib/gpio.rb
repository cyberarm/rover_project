# Virtual RPi::GPIO for basic testing without Pi
#
# Emulates https://github.com/ClockVapor/rpi_gpio
class RPi
  # Virtual RPi::GPIO for basic testing without Pi
  #
  # Emulates https://github.com/ClockVapor/rpi_gpio
  class GPIO
    BCM = 0
    BOARD = 1

    HIGH= true
    LOW = false

    Pins = {}

    # Sets numbering mode (Non functional)
    def self.set_numbering(mode)
      @mode = mode
    end

    # Sets pin to hash
    def self.setup(pin, hash)
      Pins[pin.to_s] = hash
    end

    # Sets pin HIGH
    def self.set_high(pin)
      Pins[pin.to_s][:state] = HIGH
    end

    # Sets pin LOW
    def self.set_low(pin)
      Pins[pin.to_s][:state] = LOW
    end

    # @return [Boolean] returns true if pin is high
    def self.high?(pin)
      Pins[pin.to_s][:state] ? true : false
    end

    # @return [Boolean] returns true if pin is low
    def self.low?(pin)
      Pins[pin.to_s][:state] ? false : true
    end

    # Cleans up this mess
    def self.clean_up(pin = nil)
      if pin
        Pins[pin.to_s] = nil
      else
        Pins.clear
      end
    end

    # Resets mode and cleans up (Non functional)
    def self.reset
    end

    # Virtual PWM for testing without Pi
    class PWM
      # @param pin [Integer] pin for modulation
      # @param freq [Integer] frequency of pulses
      def initialize(pin, freq)
        @pin = pin
        @freq = freq
        @cycle= nil
        @running = false
      end

      # starts pwm
      def start(cycle)
        self.duty_cycle=(cycle)
      end

      # returns pin being used for pwm
      def gpio
        @pin # This is not board pin
      end

      # current duty_cylce
      def duty_cycle
        @cycle
      end

      # sets duty_cycle
      def duty_cycle=(cycle)
        @cycle = ((cycle/255.0)*100).round.abs
      end

      # returns frequency for pwm
      def frequency
        @freq
      end

      # sets frequency of pwm
      def frequency=(freq)
        @freq = freq
      end

      # stops pwm
      def stop
        @running = false
      end

      def running?
        @running
      end
    end
  end
end
