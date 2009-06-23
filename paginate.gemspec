# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{paginate}
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jared Morgan"]
  s.date = %q{2009-06-23}
  s.description = %q{(Yet another) Pagination for DataMapper, ActiveRecord, and Array}
  s.email = %q{jmorgan@morgancreative.net}
  s.extra_rdoc_files = ["README.md", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README.md", "Rakefile", "TODO", "lib/helpers", "lib/helpers/merb.rb", "lib/helpers/shared.rb", "lib/paginate", "lib/paginate/ar.rb", "lib/paginate/dm.rb", "lib/paginate/simple.rb", "lib/paginate.rb", "lib/paginators", "lib/paginators/orm.rb", "lib/paginators/simple.rb", "spec/fixtures", "spec/fixtures/ar.rb", "spec/fixtures/dm.rb", "spec/helpers", "spec/helpers/merb_spec.rb", "spec/helpers/shared_spec.rb", "spec/paginate", "spec/paginate/ar_spec.rb", "spec/paginate/config_spec.rb", "spec/paginate/dm_spec.rb", "spec/paginate/simple_spec.rb", "spec/paginators", "spec/paginators/orm_spec.rb", "spec/paginators/simple_spec.rb", "spec/shared.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jm81/paginate/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{(Yet another) Pagination for DataMapper, ActiveRecord, and Array}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
