class Game


  EXIT_VALUE = '-1'
  EXIT_STRING = "Entering #{EXIT_VALUE} will exit the game."

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
  ]

  MODES = {
    '1' => :humans,
    '2' => :human_computer,
    '3' => :computers
  }

  LEVELS = {
    '1' => :easy,
    '2' => :medium,
    '3' => :hard
  }

  def initialize
    @player_1 = X # the computer's marker
    @player_2 = O # the user's marker
    @next_player = @player_1
  end

  def start_game
    set_game_mode

    if @mode != :humans
      set_computers_level
    end

    set_moves_order

    until game_over?
      show_board
      players_moves
    end

    clear_unplayed_spots
    show_board
    puts result
  end

  private

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

  def set_game_mode
    puts 'Game modes:'
    puts '1 - Human x Human'
    puts '2 - Human x Computer'
    puts '3 - Computer x Computer'
    puts EXIT_STRING
    print 'Select one: '

    input = get_valid_input(MODES.keys, )
    @mode = MODES[input]
  end

  def set_moves_order
    @moves_order = case @mode
                   when :humans
                     [:human, :human]
                    when :human_computer
                      [:human, :computer]
                    when :computers
                      [:computer, :computer]
                    end
  end

  def set_computers_level
    puts 'Computer(s) difficult:'
    puts '1 - Easy'
    puts '2 - Medium'
    puts '3 - Hard'
    puts EXIT_STRING
    print 'Select one: '

    input = get_valid_input(LEVELS.keys)
    @computer_level = LEVELS[input]
  end


  def empty_spots
    @board.select {|spot| ![@player_1, @player_2].include?(spot)}
  end

  def player_wins?(player_mark)
    WINNER_SPOTS.any? do |winner_spots|
      board_spot = winner_spots.map { |spot| @board[spot] }
      board_spot.uniq == [player_mark]
    end
  end

  def show_board
    puts
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]}"
    puts '===+===+==='
    puts " #{@board[3]} | #{@board[4]} | #{@board[5]}"
    puts '===+===+==='
    puts " #{@board[6]} | #{@board[7]} | #{@board[8]}"
  end

  def players_moves
    print "Player \"#{@next_player}\" enter [0-8]: "

    next_move_method = 

    send(next_move_method, @next_player)

    @next_player = if @next_player == @player_1
                     @player_2
                   else
                     @player_1
                   end
  end

  def computer_move(player_mark)
    computer_level_move = case @computer_level
                          when :easy
                            'computer_easy_spot'
                          when :Medium
                            'computer_medium_spot'
                          when :hard
                            'computer_hard_spot'
                          end

    chosen_spot = send(computer_level_move, player_mark)
    puts chosen_spot
  end

  def all_moves_made?
    @board.all? { |s| s == X || s == O }
  end

  def human_move(player_mark)
    spot = get_valid_input(empty_spots)
    @board[spot] = player_mark
  end

  def clear_unplayed_spots
    @board.map! { |spot| [@player_1, @player_2].include?(spot) ? spot : ' ' }
  end

  def result
    return "Player \"#{@player_1}\" WINS ! " if player_wins?(@player_1)
    return "Player \"#{@player_2}\" WINS ! " if player_wins?(@player_2)
    "GAME TIED !"
  end
end

game = Game.new
game.start_game
