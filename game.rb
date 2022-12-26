# frozen_string_literal: true

# This class is responsible for playing the game
class Game
  attr_accessor :lines, :word

  def initialize
    # pick a random word with 5 or more letters
    @word = File.readlines('words.txt').map(&:strip).filter { |word| word.length >= 5 }.sample
    @number_of_guesses = 10
    @lines = '_' * word.length
  end
end
