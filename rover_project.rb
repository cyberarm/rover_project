if RUBY_ENGINE == "ruby" && RUBY_VERSION < "2.1.0"
  raise "Please use a newer ruby version that supports named arguments. Ruby 2.1.0+"
end


require "sinatra/base"
require "colorize"
require "sdl2"
require "oj"

module RoverProject
  module Logger
    def log(string)
      if defined?(self.log_color)
        puts "#{Time.now.strftime('%X')}]"+"[#{self.class.to_s.split('::').last}]".send(self.log_color)+" #{string}"
      else
        puts "#{Time.now.strftime('%X')}]"+"[#{self.class.to_s.split('::').last}]"+" #{string}"
      end
    end
  end
end

if File.exist?("/proc/cpuinfo") && File.open("/proc/cpuinfo").read.include?("BCM2835")
  puts("[#{Time.now.strftime('%X')}]"+"[BOOT]".red+"Detected ARM arch, assuming running on a Pi.")
  require "rpi_gpio"
else
  puts("[#{Time.now.strftime('%X')}]"+"[BOOT]".red+"Did not detect ARM arch, using virtual gpio for testing.")
  require_relative "lib/gpio"
end

require_relative "lib/errors"
require_relative "lib/audio/audio"
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
