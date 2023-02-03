class Player::Base
  X = 'X'
  O = 'O'

  def initialize(mark, game)
    @mark = mark
    @game = game
  end

  def play_turn(board)
    raise 'This method should be implemented by a subclass and return the board after the move'
  end
end