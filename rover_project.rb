require "sinatra"

def log(tag, string)
  puts "[#{tag}] #{string}"
end

require_relative "lib/supervisor"
require_relative "lib/program/program_methods"
require_relative "lib/program/program"
require_relative "lib/motor/motor"
require_relative "lib/motor/motor_controller"
require_relative "lib/input/gamepad"
require_relative "lib/input/keyboard"
require_relative "lib/input/mouse"
require_relative "lib/hardware_interface/hardware_interface"
