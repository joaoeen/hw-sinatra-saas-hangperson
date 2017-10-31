class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_reader :word_with_guesses
  attr_reader :check_win_or_lose
  
  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @word_with_guesses = ''
    @guesses = ''
    @wrong_guesses = ''
    @word.length.times do
      @word_with_guesses << '-'
    @check_win_or_lose = :play
    end
    
  end

  def guess(letters)
    if letters == nil then
      raise ArgumentError
    end
    if /[^A-Za-z]/ =~ letters || letters.empty? then
      raise ArgumentError
    end
    if check_win_or_lose == :play then
      letters.downcase!
      letters.each_char do |letter|  
        unless @guesses.include?(letter) || @wrong_guesses.include?(letter) then  
          if @word.include? letter then
            @guesses << letter
            i = -1
            @word.count(letter).times do
              i = @word.index(letter, i+1)
              @word_with_guesses[i] = letter;
            end
            unless @word_with_guesses.include?('-') then
              @check_win_or_lose = :win
            end
          else
            @wrong_guesses << letter
            if @wrong_guesses.length >= 7 then
              @check_win_or_lose = :lose
            end
          end
          return true
        else
          return false
        end
      end
    end
    
    
  end
  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
