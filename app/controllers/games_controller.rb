require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split('')
    @result = { score: 0, message: "Sorry but #{@word} can't be built out #{@letters.join(', ')}." }
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    @answer = JSON.parse(URI.open(url).read)
    if @word.upcase.chars.all? { |element| @word.upcase.count(element) <= @letters.count(element) }
      if @answer['found']
        @result[:score] = @word.length * (100 - @result[:time].to_i)
        @result[:message] = "Congratulation! #{@word} is a valid English word !"
        cookies[:score] = @result[:score] + cookies[:score].to_i
      else
        @result[:message] = "Sorry but #{@word} does not seem to be a valid English word..."
      end
    end
  end
end
