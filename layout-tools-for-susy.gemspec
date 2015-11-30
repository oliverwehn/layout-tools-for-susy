require './lib/layout-tools-for-susy'

Gem::Specification.new do |s|
  # Release Specific Information
  s.version = LayoutTools::VERSION
  s.date = LayoutTools::DATE

  # Gem Details
  s.name = "layout-tools-for-susy"
  s.rubyforge_project = "layout-tools-for-susy"
  s.description = %q{Organize and handle layouts over multiple breakpoints}
  s.summary = %q{Handy mixins and functions to handle layout settings for multiple breakpoints.}
  s.authors = ["Oliver Wehn"]
  s.email = ["hello@oliverwehn.com"]
  s.homepage = "https://github.com/oliverwehn/layout-tools-for-susy"
  s.licenses = ["MIT", "GPL-2.0"]

  # Gem Files
  s.files = ["README.md"]
  s.files += ["CHANGELOG.md"]
  s.files += Dir.glob("lib/**/*.*")
  s.files += Dir.glob("stylesheets/**/*.*")

  # Gem Bookkeeping
  s.required_rubygems_version = ">= 1.3.6"
  s.rubygems_version = %q{1.3.6}

  s.add_dependency("sass",      ["~>3.3"])
  s.add_dependency("susy",   ["~>2.2.7"])
end