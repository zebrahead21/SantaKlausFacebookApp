require 'json'

class Markov
	
	TOKEN_SPLITTER    = %r{\s+|(\,\s+)|(\.\s+|\.$)|(\?\s+|\?$)|(\!\s+|\!$)}.freeze
	SENTENCE_END      = %r{\A[\.|\?|!]\z}.freeze
	attr_accessor :state

	def initialize
		@state = {}
	end

	def feed(texts)
		tokens = texts.split(TOKEN_SPLITTER)
		
		push(tokens)

		# puts @state.to_json
	end

	def generate_phrase(token)
		# token is a string: "Hello"
		token = token.strip	
		key = [token]
		# if @state[key] == null
		return '' unless @state[key]

		buffer = [token]
		loop do
			# key.match(SENTENCE_END)
			break if key[0] =~ SENTENCE_END
			word_hash = @state[key]

			random_number = rand()

			next_token = word_hash
				.select do |word, data|
				  data[:lower] < random_number && data[:upper] >= random_number
			end
			.to_a[0][0]

			# puts next_token		
			buffer.push(next_token)
			
			key = [next_token]
		end

		buffer.join(' ')	
		
	end

	def normalize!
		@state.each do |key, word_hash|
			result = word_hash.reduce(0) do |total, word_pair|
				# word pair contains the next word and the occurences
				total + word_pair[1][:occurence]
			end.to_f

			word_hash.each do |word, data|
				data[:probability] = data[:occurence].to_f / result
			end

			
			word_hash.reduce(0.0) do |total, word_pair|
				data = word_pair[1]
				
				data[:lower] = total
				data[:upper] = total + data[:probability]
			end
			
		end
		# puts @state.to_json
	end

	private
	def push(tokens)
		index = 0
		while index < tokens.size - 1
			current_token = tokens[index].strip
			next_token = tokens[index + 1].strip
			
                        # ["cuvant"] => {'urmatorul' => 2, 'altul' => 3} nr aparitii
			key = [current_token]
			if existing = @state[key]
				# existing {'urmatorul' => 2, 'altul' => 3}
				count = existing[next_token] || {occurence: 0}
				existing[next_token] = {occurence: count[:occurence] + 1}
			else
                		@state[key] = {next_token => {occurence: 1}}
			end
			index += 1
                end
	end

end
