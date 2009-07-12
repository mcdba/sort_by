# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sort_by}
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan Bigg"]
  s.date = %q{2009-05-26}
  s.email = %q{radarlistener@gmail.com}
  s.files = ["Rakefile", "lib/sort_by.rb", "spec/sort_by_spec.rb", "spec/fixtures/models.rb", "spec/fixtures/schema.rb", "spec/spec_helper.rb", "rails/init.rb", "README.markdown", "MIT-LICENSE"]
  s.homepage = %q{http://github.com/radar/sort_by}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{ActiveRecord extension for easier sorting by fields}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
