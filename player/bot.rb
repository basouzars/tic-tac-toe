require_relative './player_base'

class Bot < PlayerBase
  def play_turn
    @chosen_spot = nil
    send("#{difficult}_play")
    puts @chosen_spot
  end

  private

  def difficult
    @difficult ||= @game.level
  end

  def board
    @game.board
  end

  def easy_play
    @chosen_spot = board.empty_spots.first
    board.set_mark(@chosen_spot, @mark)
  end

  def medium_play
    @chosen_spot = board.empty_spots.sample
    board.set_mark(@chosen_spot, @mark)
  end

  def hard_play
    try_center_spot
    return if @chosen_spot

    empty_spots = board.empty_spots.clone
    return board.set_mark(empty_spots.first, @mark) if empty_spots.size == 1

    try_best_move(empty_spots)
    return if @chosen_spot

    good_spots.empty? ? medium_play : play_good_spots
  end

  def try_center_spot
    center_spot = Board::ORIGINAL[Board::ORIGINAL.size / 2]
    return @chosen_spot = center_spot if board.set_mark(center_spot, @mark)
  end

  def good_lines
    Game::WINNER_SPOTS.reject do |row|
      spots = row.map { |spot| board.spots[spot] }
      spots.include?(other_player_mark)
    end
  end

  def good_spots
    good_lines.flatten.uniq.reject { |spot| board.spots[spot] == @mark }
  end

  def play_good_spots
    good_corners = good_spots.select { |spot| Game::CORNERS.include?(spot) }
    @chosen_spot = (good_corners.empty? ? good_spots : good_corners).sample
    board.set_mark(@chosen_spot.to_s, @mark)
  end

  def try_best_move(empty_spots)
    self_winner_spots, other_player_winner_spots = winners_spots(empty_spots)
    return if self_winner_spots.empty? && other_player_winner_spots.empty?

    spots = self_winner_spots.empty? ? other_player_winner_spots : self_winner_spots
    @chosen_spot = spots.sample
    board.set_mark(@chosen_spot, @mark)
  end

  def winners_spots(empty_spots)
    self_winner_spots = []
    other_player_winner_spots = []

    empty_spots.each do |spot|
      board.set_mark(spot, @mark)
      self_winner_spots << spot if @game.game_over?

      board.set_mark(spot, other_player_mark, true)

      other_player_winner_spots << spot if @game.game_over?

      board.unset_spot(spot)
    end
    [self_winner_spots, other_player_winner_spots]
  end

  def other_player_mark
    @mark == Game::X ? Game::O : Game::X
  end
end
