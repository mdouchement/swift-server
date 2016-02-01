module SwiftServer
  module Models
    class Manifest < SuperModel::Base
      include SuperModel::RandomID
      include SuperModel::Timestamp::Model
      include SuperModel::Marshal::Model

      belongs_to :container, foreign_key: :container_id, class_name: 'SwiftServer::Models::Container'
      has_many :objects, foreign_key: :manifest_id, class_name: 'SwiftServer::Models::Object', dependent: :destroy

      attributes :uri
      attributes :key
      attributes :md5
      attributes :size

      validates_presence_of :uri
      validates_uniqueness_of :uri
    end
  end
end
