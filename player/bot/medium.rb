class Player::Bot::Medium < Player::Base
  def play_turn(board)
    chosen_spot = board.empty_spots.sample.to_i
    board.set_mark(chosen_spot, @mark)
  end
end