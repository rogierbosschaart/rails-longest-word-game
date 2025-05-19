require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    all_letters = ('a'..'z').to_a
    vowels = ["a", "e", "i", "o", "u", "y"]
    consonants = (all_letters - vowels).to_a
    @letters = (vowels.sample(4) + consonants.sample(5)).to_a
    @start_time = Time.now
  end

  def score
    time_end = Time.now
    start_time = Time.new(params[:start_time])
    time_passed = time_end - start_time

    url = "https://dictionary.lewagon.com/#{params[:attempt]}"
    word_serialized = URI.parse(url).read
    word = JSON.parse(word_serialized)

    letters_given = params[:letters].split("")
    attempt = params[:attempt].dup
    @attempt_feedback = params[:attempt]

    letters_given.each { |letter| attempt.sub!(letter, "") }

    if word["found"] == false
      @game_score = 0
      @message = "0 POINTS! DUMMY!"
    elsif attempt.empty?
      @game_score = ((params[:attempt].length * 10) - time_passed).to_i
      @message = "Hooray! You're score is #{@game_score}!"
    else
      @game_score = 0
      @message = "Pffff. Are you forreal???"
    end
  end
end
