module RoverProject
  class ProgramServer < Sinatra::Base
    include Logger
    set :bind, Proc.new{Supervisor.instance.host}
    set :port, Proc.new{Supervisor.instance.port}
    set :server, :puma
    set :raise_errors, true
    connections = []

    def self.instance
      @instance
    end
    def self.instance=(klass)
      @instance = klass
    end

    def initialize
      ProgramServer.instance = self
      super
    end

    def shutdown
    end

    get "/" do
      slim :index
    end

    post "/program" do
      if params[:program]
        log("Asking Supervisor to start '#{params[:program]}'...")
        Supervisor.instance.set_program(params[:program])
      elsif params[:stop]
        log("Asking Supervisor to stop '#{Supervisor.instance.active_program.class}'...")
        Supervisor.instance.stop_program
      else
        log("Bad request.")
      end

      204
    end

    get "/telemetry" do
      "#{Oj.dump(Supervisor.instance.telemetry, mode: :strict)}"
    end

    get "/css/application.css" do
      sass :application
    end
  end
end
