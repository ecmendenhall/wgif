# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wgif/version'

Gem::Specification.new do |spec|
  spec.name          = 'wgif'
  spec.version       = WGif::VERSION
  spec.authors       = ['Connor Mendenhall']
  spec.email         = ['ecmendenhall@gmail.com']
  spec.description   = %q(A command-line tool for creating animated GIFs.)
  spec.summary       = %q(A command-line tool for creating animated GIFs from YouTube videos. Uses FFmpeg and ImageMagick.)
  spec.homepage      = 'https://github.com/ecmendenhall/wgif'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ['wgif']
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_dependency 'rmagick', '2.15.3'
  spec.add_dependency 'ruby-progressbar', '1.5.1'
  spec.add_dependency 'streamio-ffmpeg', '1.0.0'
  spec.add_dependency 'typhoeus', '~> 0.6'
  spec.add_dependency 'viddl-rb', '1.1.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.3'
  spec.add_development_dependency 'pry-nav', '~> 0.2'
  spec.add_development_dependency 'rake', '~> 10.3'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'simplecov', '~> 0.8'
end
