class Player
  attr_reader(:name)
  def initialize(name)
    @name = name
    @wins = 0
    @losses = 0
  end
end

class Game
  def initialize(player)
    @player = player
    @word = nil
    @word_letters = nil
    @incorrect_guesses = 0
    @max_guesses = 8
    @incorrect_letters = []
    @guessed_letters = []
  end

  def start
    choose_word
    puts 'Good luck!'
    play_game
  end

  private

  def choose_word
    word_list = get_words
    @word = word_list.sample.chomp
    @word_letters = @word.split('').uniq
  end

  def get_words
    file = 'dictionary.txt'
    raise ArgumentError, "#{file} not found!" unless File.exist?(file)

    file_content = File.readlines(file)
    word_list = []
    file_content.each do |word|
      word_list.push(word) if word.length.between?(5, 12)
    end
    word_list
  end

  def play_game
    puts 'Guess a letter'
    guess = gets.chomp.downcase
    return play_game unless is_valid?(guess)

    handle_guess(guess)
    display_info
    return win if @word_letters.difference(@guessed_letters).empty?
    return lose if @incorrect_guesses == @max_guesses

    puts
    puts
    play_game
  end

  def is_valid?(guess)
    puts
    if @incorrect_letters.include?(guess) || @guessed_letters.include?(guess)
      puts 'You already guessed that!'
      false
    elsif guess !~ /^[a-z]$/
      puts 'Invalid input! Please type in a letter'
      false
    else
      true
    end
  end

  def handle_guess(guess)
    if @word.include?(guess)
      puts "#{guess} is in the word!"
      @guessed_letters << guess
    else
      puts "#{guess} is not in the word!"
      @incorrect_letters << guess
      @incorrect_guesses += 1
    end
  end

  def display_info
    word_info = ''
    @word.split('').each do |letter|
      if @guessed_letters.include?(letter)
        word_info << letter
      else
        word_info << '_'
      end
    end
    puts "Guesses left: #{@max_guesses - @incorrect_guesses}"
    puts "Incorrect guesses: #{@incorrect_letters.join(', ')}"
    puts word_info
  end

  def win
    puts "You win, #{@player.name}!"
  end

  def lose
    puts "You lose, #{@player.name}!"
    puts "The word was: #{@word}"
  end
end

player = Player.new('Bitflipping Barry')

game = Game.new(player)
game.start
