class FindFiles
  def initialize(rails_root)
    @rails_root = rails_root
  end

  def css_files
    Dir.glob(File.join(@rails_root, "public", "stylesheets", "**", "*.css"))
  end

  def template_files
    Dir.glob(File.join(@rails_root, "app", "views", "**", "*.{erb,haml}"))
  end
end

