if RUBY_ENGINE == "ruby" && RUBY_VERSION < "2.1.0"
  raise "Please use a newer ruby version that supports named arguments. Ruby 2.1.0+"
end

def log(tag, string)
  puts "[#{Time.now.strftime('%X')}][#{tag}] #{string}"
end

require "sinatra/base"
require "sdl2"
require "oj"

if File.exist?("/proc/cpuinfo") && File.open("/proc/cpuinfo").read.include?("BCM2835")
  log("BOOT", "Detected ARM arch, assuming running on a Pi.")
  require "rpi_gpio"
else
  log("BOOT", "Did not detect ARM arch, using virtual gpio for testing.")
  require_relative "lib/gpio"
end

require_relative "lib/errors"
require_relative "lib/supervisor"
require_relative "lib/program/program_methods"
require_relative "lib/program/program"
require_relative "lib/server/server"
require_relative "lib/motor/motor"
require_relative "lib/motor/motor_controller"
require_relative "lib/motor/controllers/l298n"
require_relative "lib/input/gamepad"
require_relative "lib/input/keyboard"
require_relative "lib/input/mouse"
require_relative "lib/hardware_interface/hardware_interface"
