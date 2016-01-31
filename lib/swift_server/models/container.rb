module SwiftServer
  module Models
    class Container < SuperModel::Base
      include SuperModel::RandomID
      include SuperModel::Timestamp::Model
      include SuperModel::Marshal::Model

      has_many :objects

      attributes :name

      validates_presence_of :name
    end
  end
end
