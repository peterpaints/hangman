class Player
  attr_accessor :name

  def initialize(name="My Little Friend")
    @name = name
  end

  def hello
    puts
    p "Hello, #{name} ..."
    puts
  end
end
