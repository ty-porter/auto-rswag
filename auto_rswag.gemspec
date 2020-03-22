# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'auto-rswag'
  s.version     = '0.1.0'
  s.date        = '2020-03-22'
  s.summary     = 'JSON to Rswag configuration'
  s.description = 'Convert raw JSON payloads to Rswag configuration to automate endpoint documentation'
  s.authors     = ['Tyler Porter']
  s.email       = 'tyler.b.porter@gmail.com'
  s.files       = Dir['**/*'].keep_if { |file| !file.match('gem') && File.file?(file) }
  s.homepage    = 'https://rubygems.org/gems/auto-rswag'
  s.license     = 'MIT'
  s.metadata    = { 'source_code_uri' => 'https://github.com/pawptart/auto-rswag' }

  s.add_development_dependency 'coveralls', '>= 0.8.23'
  s.add_development_dependency 'pry', '~> 0'
  s.add_development_dependency 'rspec', '~> 0'
  s.add_development_dependency 'rubocop', '>= 0.80.1'
end
