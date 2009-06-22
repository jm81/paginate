require 'rubygems'
gem 'rspec'
require 'spec/rake/spectask'

QBFC_ROOT = File.dirname(__FILE__)

task :default => :spec

desc "Run all specs in spec/unit directory"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--options', '"spec/spec.opts"']
  t.spec_files = FileList['spec/**/*_spec.rb']
end

require 'rake/gempackagetask'

require 'merb-core'
require 'merb-core/tasks/merb'

GEM_NAME = "paginate"
GEM_VERSION = "0.1.0"
AUTHOR = "Jared Morgan"
EMAIL = "jmorgan@morgancreative.net"
HOMEPAGE = "http://github.com/jm81/paginate/"
SUMMARY = "(Yet another) Pagination for DataMapper, ActiveRecord, and Array"

spec = Gem::Specification.new do |s|
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.md", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.require_path = 'lib'
  s.files = %w(LICENSE README.md Rakefile TODO) + Dir.glob("{lib,spec}/**/*")
  
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the plugin as a gem"
task :install do
  Merb::RakeHelper.install(GEM_NAME, :version => GEM_VERSION)
end

desc "Uninstall the gem"
task :uninstall do
  Merb::RakeHelper.uninstall(GEM_NAME, :version => GEM_VERSION)
end

desc "Create a gemspec file"
task :gemspec do
  File.open("#{GEM_NAME}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end