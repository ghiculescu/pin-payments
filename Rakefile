require 'rake'
require 'rake/testtask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Run unit tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << ['lib', 'test']
  t.pattern = 'test/unit/**/*_test.rb'
  t.verbose = true
end