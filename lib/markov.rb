require 'json'

class Markov
	
	TOKEN_SPLITTER    = %r{\s+|(\,\s+)|(\.\s+|\.$)|(\?\s+|\?$)|(\!\s+|\!$)}.freeze
	attr_accessor :state

	def initialize
		@state = {}
	end

	def feed(texts)
		tokens = texts.split(TOKEN_SPLITTER)
		
		push(tokens)

		puts @state.to_json
	end

	def generate_phrase(token)
		# token is a string: "Hello"
	
		key = [token]
		# if @state[key] == null
		return '' unless @state[key]

		buffer = [token]
		count = 0
		loop do
			break unless value = @state[key]
			break if count > 10
			count += 1

			next_token = value.first[0]
			buffer.push(next_token)
			
			key = [next_token]
		end


		buffer.join(' ')
	
		
		
	end

	private
	def push(tokens)
		index = 0
		while index < tokens.size - 1
			current_token = tokens[index]
			next_token = tokens[index + 1]
			
                        # ["cuvant"] => {'urmatorul' => 2, 'altul' => 3} nr aparitii
			key = [current_token]
			if existing = @state[key]
				# existing {'urmatorul' => 2, 'altul' => 3}
				count = existing[next_token] || 0
				existing[next_token] = count + 1
			else
                		@state[key] = {next_token => 1}
			end
			index += 1
                end
	end

end
