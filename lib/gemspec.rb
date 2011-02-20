#!/usr/bin/env ruby
version = '0.9.9.5'
raise "Could not get version so gemspec can not be built" if version.nil?
files = Dir.glob("**/*").flatten.reject do |file|
  file =~ /\.gem$/
end

gemspec = <<EOF
Gem::Specification.new do |s|
  s.name              = %q{refinerycms-generators}
  s.version           = %q{#{version}}
  s.date              = %q{#{Time.now.strftime('%Y-%m-%d')}}
  s.summary           = %q{Core generators for the Refinery CMS project.}
  s.description       = %q{Core generators for Refinery CMS including refinery_engine.}
  s.homepage          = %q{http://refinerycms.com}
  s.email             = %q{info@refinerycms.com}
  s.authors           = ["Resolve Digital"]
  s.require_paths     = %w(lib)

  #s.add_dependency    'refinerycms', '>= 0.9.9'

  s.files             = [
    '#{files.join("',\n    '")}'
  ]
  s.require_path = 'lib'
end
EOF

File.open(File.expand_path("../../refinerycms-generators.gemspec", __FILE__), 'w').puts(gemspec)