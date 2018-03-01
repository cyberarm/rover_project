module RoverProject
  class Audio
    include Logger
    def initialize
      SDL2::Mixer.init(SDL2::Mixer::INIT_OGG|SDL2::Mixer::INIT_FLAC|SDL2::Mixer::INIT_MP3)
      SDL2::Mixer.open#(22050, SDL2::Mixer::DEFAULT_FORMAT, 2, 512)
      @music  = []
      @sounds = []
      @channels = Array.new(8, false)
      @fade_ms = 100
    end

    # Returns first available channel or nil if none are available
    # @return [Integer|nil] channel
    def available_channel
      num = nil
      @channels.each_with_index do |channel, index|
        if !channel
          num = index
          break
        end
      end
      return num
    end

    # Plays sound if there is an available_channel
    # @param sound_path [String] File path to sound
    # @param loops [Integer] number of times to loop sound
    def play_sound(sound_path, loops = 0)
      if File.exist?(sound_path)
        sample = SDL2::Mixer::Chunk.load(sound_path)
        @sounds << sample
        channel = available_channel
        if channel.is_a?(Integer)
          SDL2::Mixer::Channels.play(channel, sample, loops)
          @channels[channel] = true
        else
          log("No channels available for sound playback!")
        end
      else
        log("Sound file not found at '#{sound_path}'")
      end
    end

    # Plays music, stops currently playing music
    # @param sound_path [String] File path to music
    # @param loops [Integer] number of times to loop music
    def play_music(sound_path, loops = 0)
      if File.exist?(sound_path)
        song  = SDL2::Mixer::Music.load(sound_path)
        music = SDL2::Mixer::MusicChannel.play(song, loops)
        @sounds << music
      else
        log("Music file not found at '#{sound_path}'")
      end
    end

    # Stops all playing sounds and music
    def stop_audio
      @music.each do |music|
        music.fade_out(@fade_ms)
      end
      @channels.each_with_index do |channel, index|
        SDL2::Mixer::Channels.fade_out(index, @fade_ms) if channel
      end
      @sounds.each do |sound|
        sound.destroy if sound && !sound.destroy?
      end
    end

    # Cleans up {Audio} instance
    def teardown
      stop_audio
      SDL2::Mixer.close
    end
  end
end
