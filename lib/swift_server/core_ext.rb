Time.class_eval do
  def to_s
    # Used by JSON gem
    # Follow Openstack time format: 2006-01-02T15:04:05
    utc.to_datetime.strftime("%Y-%m-%dT%H:%M:%S")
  end
end

module ROM::Relation::Materializable
  # Return last tuple from a relation coerced to an array
  #
  # @return [Object]
  #
  # @api public
  def last
    to_a.last
  end
end
