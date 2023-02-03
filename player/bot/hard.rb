class Player::Bot::Hard < Player::Base
  def play_turn(board)
    unless board.set_mark('4', @mark)
      spot = nil
      until spot
        spot = get_best_move(@mark)
        spot = nil unless board.set_mark(spot, @mark)
      end
    end
  end

  # use deep and best_scores params
  def get_best_move(board, next_player)
    empty_spots = board.empty_spots.clone
    return board.set_mark(empty_spots.first, @mark) if empty_spots.size == 1

    empty_spots.each do |spot|
      board.set_mark(spot, @mark)
      return if @game.game_over?

      board.set_mark(spot, other_player_mark)
      if @game.game_over?
        board.set_mark(spot, @mark)
      end

      board.set_mark(spot, spot)
    end

    if empty_spots == board.empty_spots
      spot = empty_spots.sample
      board.set_mark(spot, @mark)
    end
  end

  def other_player_mark
    @mark == X ? O : X
  end
end