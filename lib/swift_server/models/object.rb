module SwiftServer
  module Models
    class Object < SuperModel::Base
      include SuperModel::RandomID
      include SuperModel::Timestamp::Model
      include SuperModel::Marshal::Model

      belongs_to :container, foreign_key: :container_id, class_name: 'SwiftServer::Models::Container'
      belongs_to :manifest, foreign_key: :manifest_id, class_name: 'SwiftServer::Models::Manifest'

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
