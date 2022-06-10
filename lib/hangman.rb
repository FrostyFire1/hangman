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
end
