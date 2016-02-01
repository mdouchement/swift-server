Gem::Specification.find_by_name('swift_server').gem_dir.tap do |pwd|
  Dir[File.join(pwd, 'lib', 'swift_server', 'controllers', '**', '*.rb')].sort.each { |f| require f }
end
