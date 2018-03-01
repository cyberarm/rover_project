module RoverProject
  class ProgramServer < Sinatra::Base
    include Logger
    set :bind, Proc.new{Supervisor.instance.host}
    set :port, Proc.new{Supervisor.instance.port}
    set :server, :puma
    set :raise_errors, true

    # @return [ProgramServer] current {instance} of program server
    def self.instance
      @instance
    end

    # Sets {instance} of {ProgramServer}
    # @param klass [ProgramServer] current {instance} of program server
    def self.instance=(klass)
      @instance = klass
    end

    def initialize
      ProgramServer.instance = self
      super
    end

    # Called when supervisor shuts down
    #
    # Hold over from Thin/Server Sent Events
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
