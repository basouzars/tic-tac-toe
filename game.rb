require './board'
require './player/human'
require './player/bot'

class Game
  X = 'X'.freeze
  O = 'O'.freeze

  PLAY_AGAIN_VALUE = '0'.freeze
  EXIT_VALUE = '-1'.freeze
  EXIT_STRING = "Entering #{EXIT_VALUE} will exit the game.".freeze

  CORNERS = [0, 2, 6, 8].freeze
  WINNER_SPOTS = [
    # rows
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    # columns
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
    # diagonals
    [0, 3, 6],
    [1, 4, 7]
  ].freeze

  MODES = {
    '1' => :humans,
    '2' => :human_computer,
    '3' => :computers
  }.freeze

  LEVELS = {
    '1' => :easy,
    '2' => :medium,
    '3' => :hard
  }.freeze

  attr_reader :board
  attr_reader :level

  def initialize
    @ties = 0
    @player1_wins = 0
    @player2_wins = 0
  end

  def start_game
    loop do
      initial_configurations

      until game_over?
        @board.show
        next_player_move
      end

      game_end
    end
  end

  def get_valid_input(allowed_inputs)
    all_inputs = allowed_inputs + [EXIT_VALUE]
    input = gets.chomp
    until all_inputs.include?(input)
      puts
      puts "Allowed options: #{allowed_inputs.join(', ')}. #{EXIT_STRING}"
      print 'Please, enter one of the values informed above: '
      input = gets.chomp
    end
    abort if input == EXIT_VALUE
    input
  end

  def game_over?
    return true if @board.empty_spots.empty?

    player_wins?(@player1) || player_wins?(@player2)
  end

  private

  def initial_configurations
    set_board
    set_game_mode
    set_computers_level if @mode != :humans
    set_players
    @next_player = @player1
  end

  def game_end
    @board.clear_unplayed_spots
    @board.show
    puts result
    show_scores

    puts
    puts EXIT_STRING
    print "Enter #{PLAY_AGAIN_VALUE} to play again: "
    get_valid_input([PLAY_AGAIN_VALUE])
  end

  def set_board
    @board = Board.new
  end

  def set_game_mode
    puts
    puts 'Game modes:'
    puts '1 - Human x Human'
    puts '2 - Human x Computer'
    puts '3 - Computer x Computer'
    puts EXIT_STRING
    print 'Select one: '

    input = get_valid_input(MODES.keys)
    @mode = MODES[input]
  end

  def set_computers_level
    puts
    puts 'Computer(s) difficult:'
    puts '1 - Easy'
    puts '2 - Medium'
    puts '3 - Hard'
    puts EXIT_STRING
    print 'Select one: '

    input = get_valid_input(LEVELS.keys)
    @level = LEVELS[input]
  end

  def set_players
    class_player1, class_player2 = case @mode
                                   when :humans
                                     [Human, Human]
                                   when :human_computer
                                     human_computer_play_order
                                   when :computers
                                     [Bot, Bot]
                                   end
    @player1 = class_player1.new(X, self)
    @player2 = class_player2.new(O, self)
  end

  def human_player_position
    positions = %w[1 2]
    puts
    puts 'Markers:'
    puts "1 - #{X}"
    puts "2 - #{O}"
    puts EXIT_STRING
    print 'Enter your marker number: '
    get_valid_input(positions)
  end

  def human_computer_play_order
    human_player_position == '1' ? [Human, Bot] : [Bot, Human]
  end

  def player_wins?(player)
    WINNER_SPOTS.any? do |winner_spots|
      board_spot = winner_spots.map { |spot| @board.spots[spot] }
      board_spot.uniq == [player.mark]
    end
  end

  def next_player_move
    print "#{@next_player} enter [0-8]: "

    @next_player.play_turn

    @next_player = if @next_player == @player1
                     @player2
                   else
                     @player1
                   end
  end

  def result
    if player_wins?(@player1)
      @player1_wins += 1
      return "#{@player1} WINS ! "
    end

    if player_wins?(@player2)
      @player2_wins += 1
      return "#{@player2} WINS ! "
    end

    @ties += 1
    'GAME TIED !'
  end

  def show_scores
    puts
    puts 'SCORES:'
    puts "Ties: #{@ties}"
    puts "#{@player1} wins: #{@player1_wins}"
    puts "#{@player2} wins: #{@player2_wins}"
  end
end

game = Game.new
game.start_game
