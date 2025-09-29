class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  attr_accessor :word, :guesses, :wrong_guesses
  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses=""
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end

  def guess(letter)
    if letter.nil? || !(letter.is_a?(String)) || letter.empty? || letter.length!=1 || !(letter.match?(/\A[A-Za-z]\z/))
      raise ArgumentError
    end 
    letter = letter.downcase
    if @word.downcase.include?(letter)
      if !(@guesses.include?(letter))
        @guesses << letter
        return true
      else
        return false
      end
    else
      if !(@wrong_guesses.include?(letter))
        @wrong_guesses << letter
        return true
      else
        return false
      end
    end
  end
  def word_with_guesses()
    display = ""
    @word.each_char do |ltr|
      if @guesses.include?(ltr.downcase)
        display << ltr
      else
        display << "-" 
      end
    end 
    return display
  end 
  def check_win_or_lose()
    if @wrong_guesses.length >= 7
      return :lose
    end
    win = true
    @word.each_char do |ltr|
      if !(@guesses.include?(ltr.downcase))
        win = false
      end
    end
    if win
      return :win
    else
      return :play
    end 
  end
    
end
