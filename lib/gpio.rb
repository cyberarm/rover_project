# Virtual RPi::GPIO for basic testing without Pi
class RPi
  class GPIO
    BCM = 0
    BOARD = 1

    HIGH= true
    LOW = false

    Pins = {}

    def self.set_numbering(mode)
      @mode = mode
    end

    def self.setup(pin, hash)
      Pins[pin.to_s] = hash
    end

    def self.set_high(pin)
      Pins[pin.to_s][:state] = HIGH
    end

    def self.set_low(pin)
      Pins[pin.to_s][:state] = LOW
    end

    def self.high?(pin)
      Pins[pin.to_s][:state] ? true : false
    end

    def self.low?(pin)
      Pins[pin.to_s][:state] ? false : true
    end

    def self.clean_up(pin = nil)
      if pin
        Pins[pin.to_s] = nil
      else
        Pins.clear
      end
    end

    def self.reset
    end

    class PWM
      def initialize(pin, freq)
        @pin = pin
        @freq = freq
        @cycle= nil
        @running = false
      end

      def start(cycle)
        duty_cycle=(cycle)
      end

      def gpio
        @pin # This is not board pin
      end

      def duty_cycle
        @cycle
      end

      def duty_cycle=(cycle)
        @cycle = ((cycle/255.0)*100).round.abs
      end

      def frequency
        @freq
      end

      def frequency=(freq)
        @freq = freq
      end

      def stop
        @running = false
      end

      def running?
        @running
      end
    end
  end
end
