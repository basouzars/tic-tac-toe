class Player::Bot::Easy < Player::Base
  def play_turn(board)
    chosen_spot = board.empty_spots.first.to_i
    board.set_mark(chosen_spot, @mark)
  end
end