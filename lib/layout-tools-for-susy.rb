base_directory  = File.expand_path(File.join(File.dirname(__FILE__), '..'))
layout_tools_stylesheets_path = File.join(base_directory, 'stylesheets')

if (defined? Compass)
  require 'sassy-maps'
  Compass::Frameworks.register(
    "layout_tools",
    :path => base_directory
  )
else
  ENV["SASS_PATH"] = [ENV["SASS_PATH"], layout_tools_stylesheets_path].compact.join(File::PATH_SEPARATOR)
end

module LayoutTools
  VERSION = "0.2.0"
  DATE = "2017-06-14"
end