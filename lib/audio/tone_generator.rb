module RoverProject
  # Generates Tones/Beeps
  #
  # Using https://github.com/jstrait/nanosynth as reference/guide
  class ToneGenerator
    def initialize(type: :sine, freq:, duration:, amplitude: 1.0, sample_rate: 44100)
      @type = type
      @freq = freq
      @duration = duration
      @amplitude= amplitude
      @sample_rate = sample_rate
      @filename = false

      generate
      return self
    end

    def filename
      @filename
    end

    def generate
      number_of_samples = (@sample_rate * @duration).to_i

      samples = [].fill(0.0, 0, number_of_samples)
      position_in_period = 0.0
      position_in_period_delta = @freq.to_f / @sample_rate

      number_of_samples.times do |i|
        case @type
        when :sine
          samples[i] = Math.sin((position_in_period * (Math::PI*2)) * @amplitude)
        when :square
          samples[i] = (position_in_period >= 0.5) ? @amplitude : -@amplitude
        when :saw
          samples[i] = ((position_in_period * 2.0) - 1.0) * @amplitude
        when :triangle
          samples[i] = @amplitude - (((position_in_period * 2.0) - 1.0) * @amplitude * 2.0).abs
        when :noise
          samples[i] = rand(-@amplitude..@amplitude)
        end

        position_in_period += position_in_period_delta

        if(position_in_period >= 1.0)
          position_in_period -= 1.0
        end
      end


      @filename = generate_filename
      buffer   = WaveFile::Buffer.new(samples, WaveFile::Format.new(:mono, :float, @sample_rate))
      WaveFile::Writer.new(@filename, WaveFile::Format.new(:mono, :pcm_16, @sample_rate)) do |writer|
        writer.write(buffer)
      end
    end

    def generate_filename
      "#{Dir.pwd}/data/tmp/#{SecureRandom.uuid}.wav"
    end
  end
end
