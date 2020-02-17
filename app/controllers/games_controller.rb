require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    9.times { |_| @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @guess = params[:guess]
    @grid = params[:grid]
    @total = 0
    @result = result
  end

  def real_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    user['found']
  end

  def result
    if valid_in_grid(@guess, @grid) && real_word?(@guess)
      @total = final_score(@guess, params[:start_time])
      'Congrats'
    elsif real_word?(@guess) == false
      "#{@guess} is not a word"
    else
      'Word cannot be generated from grid'
    end
  end

  def valid_in_grid(word, grid)
    word.upcase.chars.all? do |letter|
      word.upcase.count(letter) <= grid.chars.count(letter)
    end
  end

  def final_score(guess, start_time)
    time_taken = Time.now.to_i - start_time.to_i
    (1 / time_taken) * (guess.count.to_i) * 1000
  end
end
