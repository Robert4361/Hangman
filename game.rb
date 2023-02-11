# frozen_string_literal: true

# This class is responsible for playing the game
class Game
  attr_accessor :lines, :word

  def initialize
    # pick a random word with 5 or more letters
    @word = File.readlines('words.txt').map(&:strip).filter { |word| word.length >= 5 }.sample
    @number_of_guesses = 10
    @lines = '_' * word.length
    @guessed_letters = ''
    puts @word
  end

  def word_guessed?
    !@lines.include?('_')
  end

  def play
    until word_guessed? || @number_of_guesses.zero?
      puts "Guessed letters: #{@guessed_letters}"
      puts "Guesses left: #{@number_of_guesses}"
      puts @lines
      guess
    end
  end

  def guess
    letter = guess_letter

    @number_of_guesses -= 1
    @guessed_letters += letter

    return 'wrong_letter' unless @word.include? letter

    swap_guessed_lines(letter)
  end

  private

  def guess_letter
    puts 'Write your guess'
    letter = 'xx'
    letter = gets.chomp.downcase until letter.length == 1 &&
                                       letter.between?('a', 'z') &&
                                       !@guessed_letters.include?(letter)
    letter
  end

  def swap_guessed_lines(letter)
    indexes = @word.chars.each_with_index.select { |char, _index| char == letter }.map { |array| array[1] }
    indexes.each { |index| @lines[index] = letter }
  end
end
