class Paste
  attr_reader :contents

  class << self
    def find(id)
      record = DB[:pastes].where(id: id).first
      record ? new(record[:contents]) : nil
    end
  end

  def initialize(contents)
    @contents = contents
  end

  def save
    encrypt!
    DB[:pastes].insert(contents: contents)
  end

  def decrypt(key)
    @key = key
    decrypt!
    self
  end

  def key
    @key ||= SecureRandom.hex
  end

  def encrypt!
    @contents = Base64.encode64(Encryptor.encrypt(value: contents, key: key))
  end

  def decrypt!
    @contents = Encryptor.decrypt(value: Base64.decode64(contents), key: key)
  end
end
