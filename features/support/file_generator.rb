require 'securerandom'
require 'tempfile'
require 'faker'

class FileGenerator
  ONE_MEGABYTE = 2**20

  class << self
    def with_empty_file(size_in_mb = 1)
      file = Tempfile.new('empty_file.raw')
      file.binmode

      yield file
    ensure
      file.close # Also delete file
    end

    def with_random_file(size_in_mb = 1)
      file = Tempfile.new('random_size_generated_file.raw')
      file.binmode

      size_in_mb.times { file.puts SecureRandom.random_bytes(ONE_MEGABYTE) }

      file.flush
      file.rewind # Avoid MRI 2.3 bug?!

      yield file
    ensure
      file.close # Also delete file
    end

    def with_lorem_file(size_in_mb = 1)
      lorem = Faker::Lorem.characters(ONE_MEGABYTE)
      file = Tempfile.new('random_size_generated_lorem_file.raw', encoding: Encoding::UTF_8)

      size_in_mb.times { file.puts lorem }

      file.flush
      file.rewind # Avoid MRI 2.3 bug?!

      yield file
    ensure
      begin
        file.close # Also delete file
      rescue NoMethodError
      end
    end
  end
end
