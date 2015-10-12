module JsonSchema  
  def self.string
    { type: :string }
  end

  def self.number
    { type: :number }
  end

  def self.boolean
    { type: :boolean }
  end

  def self.integer
    { type: :integer }
  end

  def self.integer_or_nil
    { type: [:integer, :nil] }
  end


  def self.datetime
    { type: :string, format: "date-time" }
  end

  def self.string_or_nil
    { type: [:string, :nil] }
  end 

  def self.any
    { type: :any }
  end
end  