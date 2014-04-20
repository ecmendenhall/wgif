module WGif
  class Installer

    DEPENDENCIES = [['ffmpeg', 'ffmpeg'],
                    ['imagemagick', 'convert']]

    def run
      if dependencies_installed?
        puts 'All dependencies are installed. Go make a gif.'
        Kernel.exit 0
      end
      if homebrew_installed?
        DEPENDENCIES.each do |dependency, binary|
          install(dependency, binary)
        end
      else
        puts "WGif can't find Homebrew. Visit http://brew.sh/ to get it."
        Kernel.exit 1
      end
      Kernel.exit 0
    end

    def dependencies_installed?
      DEPENDENCIES.map { |_, binary| installed?(binary) }.inject(:&)
    end

    def homebrew_installed?
      Kernel.system 'brew info > /dev/null'
    end

    def install(dependency, binary)
      unless installed?(binary)
        puts "Installing #{dependency}..."
        Kernel.system "brew install #{dependency}"
        puts "Successfully installed #{dependency}."
      end
    end

    def installed?(binary)
      Kernel.system "which #{binary} > /dev/null"
    end
  end
end
