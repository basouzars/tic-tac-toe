def Board
  ORIGINAL = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]

  def initialize
    @board = ORIGINAL
  end

  def board
    @board
  end

  def game_over?
    empty_spots.empty?
  end

  def empty_spots
    empties = []
    @board.zip(ORIGINAL).each { |actual, original| empties << actual if actual != original }
    empties
  end

  def set_mark(spot, mark)
    return false unless valid_play(spot)
    @board[spot.to_i] = mark
    true
  end

  def valid_play(spot)
    empty_spots.include?(spot)
  end
end