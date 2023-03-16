# frozen_string_literal: true

require 'json'
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

  def to_json(*_args)
    serialized_class = JSON.dump({
                                   word: @word,
                                   number_of_guesses: @number_of_guesses,
                                   lines: @lines,
                                   guessed_letters: @guessed_letters
                                 })
    file = File.open('save.json', 'w')
    file.puts(serialized_class)
    file.close
  end

  def from_json
    file = File.read('./save.json')
    data_hash = JSON.parse(file)
    @word = data_hash['word']
    @lines = data_hash['lines']
    @guessed_letters = data_hash['guessed_letters']
    @number_of_guesses = data_hash['number_of_guesses']
  end

  def word_guessed?
    !@lines.include?('_')
  end

  def play
    load_game
    until word_guessed? || @number_of_guesses.zero?
      puts "Guessed letters: #{@guessed_letters}"
      puts "Guesses left: #{@number_of_guesses}"
      puts @lines
      guess
    end
    puts 'Congratulations, you won!' if word_guessed?
    puts "You're out of tries, you'll win next time!" if @number_of_guesses.zero?
  end

  def guess
    letter = guess_letter

    @number_of_guesses -= 1
    @guessed_letters += letter

    return 'wrong_letter' unless @word.include? letter

    swap_guessed_lines(letter)
  end

  private

  def load_game
    puts 'Do you want to load your last game? 1-yes, 0-no'
    load = gets.chomp
    from_json if load == '1'
  end

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
