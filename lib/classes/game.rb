require 'colorize'

class Game
  attr_reader :choice, :game

  def initialize
    @choice = 0
    @game = game
  end

  def start
    puts "----------------------------------------------".red
    puts "-----H--_---A-_-N-_--G--_--M--_--A--_---N-----".yellow
    puts "----------------------------------------------".red
    puts

    sleep 1

    puts "What would you like to do?".light_cyan
    puts
    puts "1 - New Game".light_magenta
		puts "2 - Load Saved Game".light_magenta
		puts "3 - Quit".light_magenta
    puts

    @choice = gets.to_i
		run
  end

  def run
    case @choice
    when 1
      new_game
    when 2
      puts "------l---o----a----d----i----n----g------".yellow
      puts
      load_game
    when 3
      puts "---It was fun hanging out----".blue
      puts "Bye!".light_red
      exit
    else
      puts "Please type 1, 2 or 3 ..."
      start
    end
  end

  def new_game
    @hangman = Hangman.new
    @hangman.get_random_word
  end

  def load_game
    @hangman.load_game
  end
end
