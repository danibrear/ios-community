class User

  def self.user_key
    "current_user"
  end

  PROPERTIES = [:id, :name, :email]

  PROPERTIES.each do |prop|
    attr_accessor prop
  end

  def initialize(options = {})
    options.each do |key, val|
      if PROPERTIES.member? key.to_sym
        self.send("#{key}=", val)
      end
    end
  end

  def save
    defaults = NSUserDefaults.standardUserDefaults
    defaults[User.user_key] = NSKeyedArchiver.archivedDataWithRootObject(self)
  end

  def self.find
    defaults = NSUserDefaults.standardUserDefaults
    data = defaults[user_key]
    NSKeyedUnarchiver.unarchiveObjectWithData(data) if data
  end

  def initWithCoder(decoder)
    self.init
    PROPERTIES.each do |prop|
      saved_value = decoder.decodeObjectForKey(prop.to_s)
      self.send("#{prop}=", saved_value)
    end
    self
  end

  def encodeWithCoder(encoder)
    PROPERTIES.each do |prop|
      encoder.encodeObject(self.send(prop), forKey: prop.to_s)
    end
  end

end
