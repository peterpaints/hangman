require_relative 'classes/game'
require_relative 'classes/hangman'
require_relative 'classes/player'

game = Game.new
player = Player.new

player.hello
game.start
