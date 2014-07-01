$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'jm81-paginate/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'jm81-paginate'
  s.version     = Paginate::VERSION.dup
  s.authors     = ['Jared Morgan']
  s.email       = ['jmorgan@morgancreative.net']
  s.homepage    = %q{http://github.com/jm81/paginate}
  s.summary     = %q{Pagination for DataMapper, ActiveRecord, and Array}
  s.description = <<EOF
This paginate library assists in paginating collections and results of database
queries. It is particularly designed for use with DataMapper and ActiveRecord,
and for the Merb and Rails frameworks, but can be used in many other situations.
EOF

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md"]
end
