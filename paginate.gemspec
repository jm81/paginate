# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{paginate}
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jared Morgan"]
  s.date = %q{2009-07-05}
  s.email = %q{jmorgan@morgancreative.net}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.md",
     "Rakefile",
     "TODO",
     "VERSION",
     "lib/helpers/merb.rb",
     "lib/helpers/shared.rb",
     "lib/paginate.rb",
     "lib/paginate/ar.rb",
     "lib/paginate/dm.rb",
     "lib/paginate/simple.rb",
     "lib/paginators/orm.rb",
     "lib/paginators/simple.rb",
     "paginate.gemspec",
     "spec/fixtures/ar.rb",
     "spec/fixtures/dm.rb",
     "spec/helpers/merb_spec.rb",
     "spec/helpers/shared_spec.rb",
     "spec/paginate/ar_spec.rb",
     "spec/paginate/config_spec.rb",
     "spec/paginate/dm_spec.rb",
     "spec/paginate/simple_spec.rb",
     "spec/paginators/orm_spec.rb",
     "spec/paginators/simple_spec.rb",
     "spec/shared.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/jm81/paginate}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Pagination for DataMapper, ActiveRecord, and Array}
  s.test_files = [
    "spec/fixtures/ar.rb",
     "spec/fixtures/dm.rb",
     "spec/helpers/merb_spec.rb",
     "spec/helpers/shared_spec.rb",
     "spec/paginate/ar_spec.rb",
     "spec/paginate/config_spec.rb",
     "spec/paginate/dm_spec.rb",
     "spec/paginate/simple_spec.rb",
     "spec/paginators/orm_spec.rb",
     "spec/paginators/simple_spec.rb",
     "spec/shared.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
