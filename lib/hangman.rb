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
    @cur_guesses = 0
    @max_guesses = 8
    @incorrect_guesses = []
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

  end
end
