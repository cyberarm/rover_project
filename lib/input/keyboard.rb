module RoverProject
  module Input
    class Keyboard
      # @return [Boolean] Returns true if the `key_string` is pressed
      def pressing?(key_string)
      end

      # @return [Boolean] Returns true if the `key_string` is recently released
      def released?(key_string)
      end
    end
  end
end
