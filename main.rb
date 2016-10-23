require 'koala'
require_relative './config/secrets.rb'
require_relative './lib/markov.rb'

markov = Markov.new

if File.exists?('./tmp/state')
	puts "Exista"
	dump = File.read('./tmp/state')
	markov = Marshal.load(dump)
else
	texts = File.read('./samples/sample_1').force_encoding("utf-8")

	markov.feed(texts)
	markov.normalize!
end

post = markov.generate_phrase()

puts post

api = Koala::Facebook::API.new(FB_APP_TOKEN)
api.put_wall_post(post)

unless File.exists?('./tmp/state')
	puts "Does not exist"
	File.open('./tmp/state', 'w') do |file|
		Marshal.dump(markov, file)
	end
end
