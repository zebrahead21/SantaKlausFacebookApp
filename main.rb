require 'koala'
require_relative './config/secrets.rb'
require_relative './lib/markov.rb'

markov = Markov.new

texts = File.read('./samples/sample_2').force_encoding("utf-8")

markov.feed(texts)
post = markov.generate_phrase(", ")

puts "Phrase: #{post}"

api = Koala::Facebook::API.new(FB_APP_TOKEN)
# api.put_wall_post(post)

