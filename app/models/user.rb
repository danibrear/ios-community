class User

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

  end

end
