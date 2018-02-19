module RoverProject
  module Input
    class GamePad
      def initialize
        if SDL2::Joystick.num_connected_joysticks == 0
          log("GamePad", "No controller detected, exiting...")
          exit
        end
      end

      def event(sdl_event)
      end

      # @return [Integer] between -100 to +100
      def left_stick_x
      end

      # @return [Integer] between -100 to +100
      def left_stick_y
      end

      # @return [Integer] between -100 to +100
      def right_stick_x
      end

      # @return [Integer] between -100 to +100
      def right_stick_y
      end

      # @return [Boolean] Returns true if the `left_bumper` is pressed
      def left_bumper
      end

      # @return [Boolean] Returns true if the `right_bumper` is pressed
      def right_bumper
      end

      # @return [Integer] between 0 to 100
      def left_trigger
      end

      # @return [Integer] between 0 to 100
      def right_trigger
      end

      # @return [Boolean] Returns true if the `pause` button is pressed
      def pause
      end

      # @return [Boolean] Returns true if the `start` button is pressed
      def start
      end

      # @return [Boolean] Returns true if the `dpad_left` is pressed
      def dpad_left
      end

      # @return [Boolean] Returns true if the `dpad_right` is pressed
      def dpad_right
      end

      # @return [Boolean] Returns true if the `dpad_up` is pressed
      def dpad_up
      end

      # @return [Boolean] Returns true if the `dpad_down` is pressed
      def dpad_down
      end

      # @return [Boolean] Returns true if the `x` button is pressed
      def x
      end

      # @return [Boolean] Returns true if the `y` button is pressed
      def y
      end

      # @return [Boolean] Returns true if the `b` button is pressed
      def b
      end

      # @return [Boolean] Returns true if the `a` button is pressed
      def a
      end
    end
  end
end
