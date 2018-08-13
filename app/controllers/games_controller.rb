require 'json'
require 'rest-client'

class GamesController < ApplicationController
  def new
    @letters = Array.new(9) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase.chars
    @letters = JSON.parse(params[:letters])
    if !letters_including_word?(@word, @letters)
      @message = 'Your word was not found in the list!'
    elsif !english_word?(@word)
      @message = 'NOT ENGLISH!'
    else
      @message = "Nice, Your score is #{@word.length}"
    end
  end

  def letters_including_word?(word, letters)
    remaining_letters = letters.dup
    word.each do |letter|
      if remaining_letters.index(letter).nil?
        return false
      else
        remaining_letters.delete_at(remaining_letters.index(letter))
      end
    end
    true
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word.join.downcase}"
    serialized = RestClient.get(url)
    hash = JSON.parse(serialized)
    hash["found"]
  end
end
