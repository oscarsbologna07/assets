source 'https://rubygems.org'
gemspec

unless ENV['TRAVIS']
  gem 'byebug', require: false, platforms: :mri
  gem 'yard',   require: false
end

gem 'hanami-utils',   '~> 1.1', git: 'https://github.com/hanami/utils.git',   branch: '1.1.x'
gem 'hanami-helpers', '~> 1.1', git: 'https://github.com/hanami/helpers.git', branch: '1.1.x'
gem 'hanami-view',    '~> 1.1', git: 'https://github.com/hanami/view.git',    branch: '1.1.x'

gem 'hanami-emberjs',        path: 'spec/support/fixtures/hanami-emberjs',        require: false
gem 'hanami-compass',        path: 'spec/support/fixtures/hanami-compass',        require: false
gem 'hanami-foo-compressor', path: 'spec/support/fixtures/hanami-foo-compressor', require: false

gem 'hanami-devtools', require: false, git: 'https://github.com/hanami/devtools.git'
gem 'coveralls',       require: false
