class Board
  ORIGINAL = %w[0 1 2 3 4 5 6 7 8].freeze

  attr_reader :spots

  def initialize
    @spots = ORIGINAL.map(&:itself)
  end

  def empty_spots
    @spots.zip(ORIGINAL).map do |actual, original|
      actual if actual == original
    end.compact
  end

  def set_mark(spot, mark, force = false)
    return false if !valid_play(spot) && !force

    @spots[spot.to_i] = mark
    true
  end

  def unset_spot(spot)
    @spots[spot.to_i] = spot
  end

  def valid_play(spot)
    empty_spots.include?(spot)
  end

  def show
    puts
    puts " #{@spots[0]} | #{@spots[1]} | #{@spots[2]}"
    puts '===+===+==='
    puts " #{@spots[3]} | #{@spots[4]} | #{@spots[5]}"
    puts '===+===+==='
    puts " #{@spots[6]} | #{@spots[7]} | #{@spots[8]}"
  end

  def clear_unplayed_spots
    empty_spots.each { |spot| @spots[spot.to_i] = ' ' }
  end
end
