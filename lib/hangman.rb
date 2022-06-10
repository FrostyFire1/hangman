require 'yaml'
class Player
  attr_accessor(:name, :wins, :losses)
  def initialize(name, wins = 0, losses = 0)
    @name = name
    @wins = wins
    @losses = losses
  end

  def to_yaml
    YAML.dump({
      name: @name,
      wins: @wins,
      losses: @losses
    })
  end

  def self.from_yaml(string)
    data = YAML.load string
    new(data[:name], data[:wins], data[:losses])
  end
end

class Game

  def initialize(player, word = nil, word_letters = nil, incorrect_guesses = 0, 
                 max_guesses = 8, incorrect_letters = [], guessed_letters = [])
    @player = player
    @word = word
    @word_letters = word_letters
    @incorrect_guesses = incorrect_guesses
    @max_guesses = max_guesses
    @incorrect_letters = incorrect_letters
    @guessed_letters = guessed_letters
  end

  def to_yaml
    YAML.dump({
      player: @player,
      word: @word,
      word_letters: @word_letters,
      incorrect_guesses: @incorrect_guesses,
      max_guesses: @max_guesses,
      incorrect_letters: @incorrect_letters,
      guessed_letters: @guessed_letters
    })
  end

  def self.from_yaml(string)
    data = YAML.load(string, permitted_classes: [Symbol, Game, Player])
    new(data[:player], data[:word], data[:word_letters], data[:incorrect_guesses],
        data[:max_guesses], data[:incorrect_letters], data[:guessed_letters])
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
    @word_letters = @word.split('').uniq
  end

  def get_words
    file = 'dictionary.txt'
    raise ArgumentError, "#{file} not found!" unless File.exist?(file)

    file_content = File.readlines(file)
    word_list = []
    file_content.each do |word|
      word_list.push(word.chomp) if word.chomp.length.between?(5, 12)
    end
    word_list
  end

  def play_game
    puts 'Guess a letter or type save to save and quit the game!'
    guess = gets.chomp.downcase
    return save if guess == 'save'
    return play_game unless is_valid?(guess)

    handle_guess(guess)
    display_info
    return win if @word_letters.difference(@guessed_letters).empty?
    return lose if @incorrect_guesses == @max_guesses

    puts
    puts
    play_game
  end

  def save
    game_id = Dir.entries('saves').length - 1 # - 1 because this lists "." and ".."
    save = File.open("saves/game#{game_id}.yaml", 'w+')
    save.puts to_yaml
  end
  def is_valid?(guess)
    puts
    if @incorrect_letters.include?(guess) || @guessed_letters.include?(guess)
      puts 'You already guessed that!'
      puts "Guessed letters: #{(@incorrect_letters << @guessed_letters).flatten.uniq.join(', ')}"
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
      word_info << ' '
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

def ask_load
  puts 'Would you like to load a save? Y/y for yes, anything else for no'
  response = gets.chomp.downcase
  if response == 'y'
    puts 'Which save would you like to load?'
    save_list = Dir.entries('saves')
    puts 'Available saves:'
    save_list.each_with_index { |save, index| puts save if index > 1}
    chosen_save = gets.chomp.downcase
    if File.exist?("saves/#{chosen_save}")
      return File.read("saves/#{chosen_save}")
    else
      puts "File doesn't exist!"
      return
    end
  end
end

player = Player.new('Bitflipping Barry')
to_load = ask_load

game = if to_load.nil?
         Game.new(player)
       else
         Game.from_yaml(to_load)
       end
game.start

