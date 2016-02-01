module SwiftServer
  module Controllers
    module Concerns
      module CleanerManager
        def remove_empty_directories
          until (empty_dirs = find_empty_directories).empty?
            empty_dirs.each { |d| Dir.rmdir d }
          end
        end

        def find_empty_directories
          Dir["storage/**/*"]
            .select { |d| File.directory? d }
            .select { |d| (Dir.entries(d) - %w(. ..)).empty? }
        end
      end
    end
  end
end
