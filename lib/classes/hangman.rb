require 'colorize'

class Hangman
  attr_accessor :word, :letter, :turns, :hidden_word
  attr_reader :file, :letters_tried

  def initialize
    @file = File.open('dictionary.txt', "r")
    @word = @file.to_a.sample.downcase.chomp
    @hidden_word = []
    @letter = letter
    @turns = 0
    @letters_tried = []
  end

  def right_length(word)
    @word.length.between? 5, 12
  end

  def get_random_word
    while !right_length(@word)
      temp_word = File.open('dictionary.txt', "r").to_a.sample.downcase.chomp
      @word = temp_word
    end
    make_hidden_word
    @turns = @hidden_word.length - 1
    guess_word
  end

  def make_hidden_word
    @word.length.times { @hidden_word << "_ " }
    puts @hidden_word.join(" ")
    @hidden_word
  end

  def guess_word
    puts "\nGive it a go ... Give me a letter.".yellow
    puts
    puts "You can save your progress by typing: '0', or just exit with '1'".blue
    puts
    @letter = gets.downcase.chomp
    guess_letter(@letter)
  end

  def guess_letter(letter)
    if letter == "0"
      save_game
      puts
      puts "Game saved. See you later!".cyan
      puts
      exit
    elsif letter == "1"
      puts
      puts "Woah, It's that bad, huh? \u{1F928}".red
      puts
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts
      exit
    elsif !('a'..'z').to_a.include? letter
      puts
      puts "Nope! Give me a valid letter, now. No games ...".magenta
      puts
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      guess_word
    elsif @letters_tried.include? letter
      puts
      puts "You've tried that already! \u{1F621}".light_red
      puts
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      guess_word
    elsif @word.include? letter
      puts
      puts "\u{1F4AA} \u{1F4AA} \u{1F4AA}. You're right! '#{letter}' is in there!".yellow
      puts
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      @letters_tried << @letter if @letter.is_a? String
      # @turns -= 1

      word_indices = @word.split("").each_index.select { |i| @word[i] == letter }
			word_indices.each do |i|
				@hidden_word[i] = letter
      end
      if @word.to_s == @hidden_word.join("").to_s
        puts
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
				puts "You win!! \u{1F3C6}".cyan
				puts "There you go. Genius!!! It was #{@word}.".light_cyan
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
				puts
				exit
      end
    else
      puts
      puts "'#{@letter}' \u{1F925} Not quite ...".light_red
      @letters_tried << @letter if @letter.is_a? String
      @turns -= 1
    end

    puts
    puts @hidden_word.join(" ")
    puts
    puts "Letters tried: #{@letters_tried.join("")}".red
    puts
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts "You have #{@turns} tries left. \u{1F937}".yellow
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    guess_word unless no_turns_left
  end

  def no_turns_left
		if @turns == 0
      puts
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts
			puts "You lose...Sorry \u{1F4A9} \u{1F4A9}".red
      puts
			puts "You're still smart. Don't let my judging you make you doubt it \u{1F609}.".cyan
      puts
      puts "Aaaaaand the word was '#{@word}'".magenta
      puts "......."
      puts
			puts "Try again?"
      puts
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts
      exit
		end
  end

  def save_game
		data = YAML::dump(self)

		File.open("saves.yml", "w") { |file| file.write(data) }

		3.times do
			sleep 1
			puts ". "
		end
  end

	def load_game
		saved_game = YAML::load(File.open("saves.yml", "r"))
		self.hidden_word = saved_game.hidden_word
		self.word = saved_game.word
		self.turns = saved_game.turns
    self.letters_tried = saved_game.letters_tried

		puts @hidden_word.join(" ")
		guess_word
	end
end
