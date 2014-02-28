module WGif
  class Installer

    DEPENDENCIES = [['ffmpeg', 'ffmpeg'], ['imagemagick', 'convert']]

    def run
      if homebrew_installed?
        DEPENDENCIES.each do |dependency, binary|
          install(dependency, binary)
        end
        puts "All dependencies sucessfully installed."
      else
        puts "WGif can't find Homebrew. Visit http://brew.sh/ to get it."
      end
      Kernel.exit 0
    end

    def homebrew_installed?
      Kernel.system 'brew info > /dev/null'
    end

    def install(dependency, binary)
      unless installed?(binary)
        puts "Installing #{dependency}..."
        Kernel.system "brew install #{dependency} > /dev/null"
        puts "Successfully installed #{dependency}."
      end
    end

    def installed?(binary)
      Kernel.system "which #{binary} > /dev/null"
    end

  end
end
