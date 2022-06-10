class Player
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
    @word_letters = @word.split('').uniq
    @cur_guesses = 0
    @max_guesses = 8
    @incorrect_guesses = []
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
    @word = word_list.sample
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
    @cur_guesses += 1
    return win if @word_letters.difference(@guessed_letters).empty?
    return lose if @cur_guesses == @max_guesses
    play_game
  end

  def is_valid?(guess)
    [@incorrect_guesses.include?(guess),
     @guessed_letters.include?(guess),
     guess !~ /^[a-z]$/].none?
  end

  def handle_guess(guess)
    if @word.include?(guess)
      @guessed_letters << guess
    else
      @incorrect_guesses << guess
    end
  end
end
