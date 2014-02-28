module WGif
  class Installer

    DEPENDENCIES = ['ffmpeg', 'imagemagick']

    def run
      if homebrew_installed?
      DEPENDENCIES.each do |dependency|
        install(dependency)
      end
      else
        puts "WGif can't find Homebrew. Visit http://brew.sh/ to get it."
        Kernel.exit 0
      end
    end

    def homebrew_installed?
      Kernel.system 'brew info'
    end

    def install(dependency)
      unless installed?(dependency)
        Kernel.system "brew install #{dependency}"
      end
    end

    def installed?(dependency)
      Kernel.system "which #{dependency}"
    end

  end
end
