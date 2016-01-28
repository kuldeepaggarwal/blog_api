class GuestUser
  def self.new(attrs = {})
    User.new(attrs.stringify_keys.merge('role' => :guest))
  end
end
