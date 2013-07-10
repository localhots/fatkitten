class Paste
  attr_reader :contents, :type

  class << self
    def find(id)
      record = DB[:pastes].where(id: id).first
      record ? new(record[:contents], record[:type]) : nil
    end
  end

  def initialize(contents, type = nil)
    @contents = contents
    @type = type
  end

  def save
    encrypt!
    DB[:pastes].insert(contents: contents, type: type)
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

  def highlighted
    Pygments.highlight(@contents, lexer: 'ruby', options: { linenos: 'table' })
  end

  def paragraph
    "<pre>#{@contents}</pre>"
  end

  def html
    type ? highlighted : paragraph
  end
end
