# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wgif/version'

Gem::Specification.new do |spec|
  spec.name          = "wgif"
  spec.version       = WGif::VERSION
  spec.authors       = ["Connor Mendenhall"]
  spec.email         = ["ecmendenhall@gmail.com"]
  spec.description   = %q{A command-line tool for creating animated GIFs.}
  spec.summary       = %q{A command-line tool for creating animated GIFs from YouTube videos. Uses FFmpeg and ImageMagick.}
  spec.homepage      = "https://github.com/ecmendenhall/wgif"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ["wgif"]
    #spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_dependency "rmagick"
  spec.add_dependency "ruby-progressbar"
  spec.add_dependency "streamio-ffmpeg"
  spec.add_dependency "typhoeus", "~> 0.6"
  spec.add_dependency "viddl-rb"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "simplecov"
end
