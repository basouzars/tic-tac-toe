class PlayerBase
  attr_reader :mark

  def initialize(mark, game)
    @mark = mark
    @game = game
  end

  def to_s
    "Player \"#{@mark}\""
  end

  def play_turn
    raise 'This method should be implemented by a subclass'
  end
end
