redmine_version_file = File.expand_path("../../../lib/redmine/version.rb",__FILE__)
if (!File.exists? redmine_version_file)
  redmine_version_file = File.expand_path("lib/redmine/version.rb");
end
version_file = IO.read(redmine_version_file)
redmine_version_minor = version_file.match(/MINOR =/).post_match.match(/\d/)[0].to_i
redmine_version_major = version_file.match(/MAJOR =/).post_match.match(/\d/)[0].to_i

# XXX holidays gem is installed by other plugin
#gem "holidays", "< 3.0.0"
gem "icalendar"
# XXX "Bundler cannot continue." because nokogiri is specified twice
#gem "nokogiri", ">= 1.6.7.2"
gem "open-uri-cached"
gem "prawn"
gem 'json'
gem 'sidekiq'
gem 'octokit'
gem 'inifile'

# group :development do
#   gem "inifile"
# end

group :test do
  gem 'chronic'
  gem 'ZenTest', "=4.5.0" # 4.6.0 has a nasty bug that breaks autotest
  gem 'autotest-rails'
  #gem 'cucumber-rails', '~>1.4.0', require: false
  gem 'cucumber-rails', require: false
  gem "culerity"
  gem "cucumber", "~> 1.2.0"
  #gem "capybara", "~> 1.0"
  #gem "faye-websocket"
  gem "poltergeist"
  gem "database_cleaner"
  gem "gherkin"
  gem "rspec"
  gem "rspec-rails"
  gem "ruby-prof", :platforms => [:ruby]
  gem "spork"
  gem "test-unit", "=1.2.3"
  gem "timecop", '~> 0.3.5'
end

# moved out of the dev group so backlogs can be tested by the user after install. Too many issues of weird setups with apache, nginx, etc.
# thin doesn't work for jruby
gem "thin", :platforms => [:ruby]
