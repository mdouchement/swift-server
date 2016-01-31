module SwiftServer
  module Controllers
    class Object < SuperModel::Base
      include SuperModel::RandomID
      include SuperModel::Timestamp::Model
      include SuperModel::Marshal::Model

      belongs_to :container
      belongs_to :manifest

      attributes :uri
      attributes :key
      attributes :size
      attributes :content_type
      attributes :file_path
      attributes :md5

      validates_presence_of :uri
      validates_uniqueness_of :uri
    end
  end
end