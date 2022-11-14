class GamesController < ApplicationController

  def new
    @grid = []
    20.times { @grid << ('A'..'Z').to_a.sample(1)[0] }
  end

  def score
    @grid = params[:grid].split(" ")
    attempt = params[:word]
    dic_lookup = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
    is_english = dic_lookup["found"]
    valid_attempt = true
    attempt.chars.each do |letter|
      @grid.include?(letter.upcase) ? @grid.slice!(@grid.index(letter.upcase)) : valid_attempt = false
    end
    @result_hash = compute_hash_result(attempt, is_english, valid_attempt)
  end

  def compute_hash_result(attempt, is_english, valid_attempt)
    score = 0
    if is_english && valid_attempt
      score = attempt.length
      message = "Well done!"
    elsif !is_english
      message = "Your word is not an english word."
    elsif !valid_attempt
      message = "Your word is not in the grid."
    end
    { score: score, message: message }
  end
end
