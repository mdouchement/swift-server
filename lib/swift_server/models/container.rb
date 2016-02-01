module SwiftServer
  module Models
    class Container < SuperModel::Base
      include SuperModel::RandomID
      include SuperModel::Timestamp::Model
      include SuperModel::Marshal::Model

      has_many :objects, foreign_key: :container_id, class_name: 'SwiftServer::Models::Object'

      attributes :name

      validates_presence_of :name
    end
  end
end
