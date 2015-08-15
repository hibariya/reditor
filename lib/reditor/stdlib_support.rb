module StdlibSupport
  class StdlibSpec < Struct.new(:name, :path); end

  def stdlib_specs
    stdlib_paths.map {|lib| StdlibSpec.new(lib.basename.to_s, lib.to_path) }
  end

  private

  def stdlib_paths
    return [] unless path = ruby_stdlib_path

    Pathname.glob(path.join('*')).select(&:directory?)
  end

  def ruby_stdlib_path
    return nil unless path = ENV['RUBY_SRC']

    Pathname.new(path).join('ext')
  end
end
