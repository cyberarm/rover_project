require "sinatra/base"
require "sdl2"

def log(tag, string)
  puts "[#{Time.now.strftime('%X')}][#{tag}] #{string}"
end

require_relative "lib/supervisor"
require_relative "lib/program/program_methods"
require_relative "lib/program/program"
require_relative "lib/program/server"
require_relative "lib/motor/motor"
require_relative "lib/motor/motor_controller"
require_relative "lib/input/gamepad"
require_relative "lib/input/keyboard"
require_relative "lib/input/mouse"
require_relative "lib/hardware_interface/hardware_interface"
