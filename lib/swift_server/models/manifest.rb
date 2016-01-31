module SwiftServer
  module Controllers
    class Manifest < SuperModel::Base
      include SuperModel::RandomID
      include SuperModel::Timestamp::Model
      include SuperModel::Marshal::Model

      belongs_to :container
      has_many :objects

      attributes :uri
      attributes :key
      attributes :md5
      attributes :size

      validates_presence_of :uri
      validates_uniqueness_of :uri
    end
  end
end
