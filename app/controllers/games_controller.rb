require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    chars = [*('a'..'z')].flatten
    rand_chars = Array.new(8) { chars.sample }
    @letters = rand_chars.map { |letter| letter.upcase }
    session[:letters] = @letters
  end

  def part_of_letters(word)
    word.chars.all? do |letter|
      session[:letters].include?(letter.upcase) && @word.count(letter.upcase) <= session[:letters].count(letter.upcase)
    end
  end

  def score
    input = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{input}"
    serialized_words = URI.open(url).read
    words = JSON.parse(serialized_words)
    @found = words["found"]
    @word = words["word"]

    if @found
      if part_of_letters(@word)
        @result = "Congrulations! #{@word.capitalize} is valid!"
      else
        @result = "Sorry, #{@word.capitalize} cannot be built from the letters in the grid"
      end
    else
      @result = "Sorry, #{@word.capitalize} is not a valid English word!"
    end
  end
end
