require_relative './player_base'

class Human < PlayerBase
  def play_turn
    spot = @game.get_valid_input(@game.board.empty_spots)
    @game.board.set_mark(spot, @mark)
  end
end
