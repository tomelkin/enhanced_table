class LibDirectory
  def self.file(filename)
    return File.join(File.dirname(__FILE__), '..', '..', 'lib', filename)
  end
end