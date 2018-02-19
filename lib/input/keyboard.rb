module RoverProject
  module Input
    class Keyboard

      attr_reader :keys
      def initialize
        @keys = {}
      end

      def event(sdl_event)
        case sdl_event
        when SDL2::Event::KeyUp
          @keys["#{SDL2::Key::Scan.name_of(sdl_event.scancode)}"] = :released
        when SDL2::Event::KeyDown
          @keys["#{SDL2::Key::Scan.name_of(sdl_event.scancode)}"] = :holding
        end
        # puts "scancode: #{sdl_event.scancode}(#{SDL2::Key::Scan.name_of(sdl_event.scancode)})"
      end

      # @return [Boolean] Returns true if the `key_string` is pressed
      def holding?(key_string)
        if @keys[key_string] && @keys[key_string] == :holding
          true
        else
          false
        end
      end

      # @return [Boolean] Returns true if the `key_string` is recently released
      def released?(key_string)
        if @keys[key_string] && @keys[key_string] == :released
          key = @keys[key_string]
          @keys[key_string] = nil
          return key
        end
      end
    end
  end
end
