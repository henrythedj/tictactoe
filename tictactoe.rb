class Player
	@@number_of_players = 0
	def self.number_of_players
		return @@number_of_players
	end
	def initialize(name)
		@name = name
		@wins = 0
		@@number_of_players += 1
	end
	
	attr_accessor :name, :wins, :number_of_players
end

class Game
	
	

	def initialize(player1, player2)
		@player1 = player1
		@player2 = player2
		@move = 0
		@array = []
		@won = 0
		@wins = [[0,1,2],[0,3,6],[0,4,8],[1,4,7],[2,5,8],[2,4,6],[3,4,5],[6,7,8]]
		@example_array = []
		@game_won = 0
		9.times do |i| @example_array.push (i+1).to_s end
		9.times do @array.push "-" end
		puts "#{@player1.name} will go first and play as 'X'. #{@player2.name} will move second and play as 'O'. Good luck, losers..."
		self.show_moves
	end

	def move(player, choice)
		choice = choice.to_i
		@array[choice-1] = "X" if player.name == @player1.name
		@array[choice-1] = "O" if player.name == @player2.name
		@example_array[choice-1] = '-'
		@move += 1
		self.check_win
	end

	def show_moves
		puts "These are the available moves:"
		puts @example_array[0] + "|" + @example_array[1] + "|" + @example_array[2]
		puts @example_array[3] + "|" + @example_array[4] + "|" + @example_array[5]
		puts @example_array[6] + "|" + @example_array[7] + "|" + @example_array[8]
	end

	def check_win
		puts "Checking..."	
		8.times do |i|
			@x = 0
			@o = 0
			self.wins[i].each do |j|
				@x += 1 if @array[j] == "X"
				@o += 1	if @array[j] == "O"
				self.win(@player1) if @x == 3
				self.win(@player2) if @o == 3
			end
		end
		if @won ==0
			puts "No winner yet!"
		end
	end

	def win(player)
		player.wins +=1
		self.board_status
		puts "#{player.name} wins and has won #{player.wins} game(s)"
		@won = 1
		@game_won = 1
	end

	def board_status
		@move == 1 ? (puts "#{@move} move has been made") : (puts "#{@move} moves have been made")
		puts "Current Board:"
		puts @array[0] + "|" + @array[1] + "|" + @array[2]
		puts @array[3] + "|" + @array[4] + "|" + @array[5]
		puts @array[6] + "|" + @array[7] + "|" + @array[8]
	end

	protected :win, :check_win
	attr_accessor :player1, :player2, :example_array, :game_won, :won, :wins
end

def roboto_move(current_game,example,move)
	my_robot_move = rand(1..9).to_s
	until example.include? my_robot_move
		my_robot_move = rand(1..9).to_s
	end
	return my_robot_move.to_s
end

#Gameplay
mr_roboto = Player.new("mr roboto")
players = []
players[0] = mr_roboto
keep_playing = "y"
while keep_playing == "y"
	puts "Would you like to add a new player? (y/n)"
	add_player = gets.chomp.downcase
	if add_player == "y"
		puts "What is the new challenger's name?"
		new_playername = gets.chomp
		num = Player.number_of_players
		new_playername = Player.new(new_playername)
		players[num] = new_playername
		next
	elsif add_player != "n"
		puts "You need to choose 'y' or 'n'"
		next
	elsif players.length < 2
		puts "You need at least one more player"
		next
	end
	selecting_players = "NA"
	while selecting_players == "NA"
		puts "Who is playing in this game?"
		puts "These are the available players (mr roboto is an AI):"
		for i in 0...players.length
			puts "Person " + i.to_s + ": " + players[i].name
		end
		puts "Who will be player 1? (select the number of an available player)"
		select_player1 = gets.chomp.to_i
		puts "Who will be player 2? (select the number of an available player)"
		select_player2 = gets.chomp.to_i
		if select_player1.between?(0,players.length - 1) && select_player2.between?(0,players.length - 1) && select_player1 != select_player2
			selecting_players = "go"
		else
			puts "Invalid player selection, try again"
		end
	end

	in_game = "y"
	while in_game == "y"
		current_game = Game.new(players[select_player1], players[select_player2])
		i = 1
		while i <= 9 && current_game.game_won == 0
			puts "It is #{current_game.player1.name}'s turn." if i%2 != 0
			puts "It is #{current_game.player2.name}'s turn." if i%2 == 0
			current_game.board_status
			current_game.show_moves
			valid_move = "n"
			while valid_move == "n"
				if current_game.player1.name == "mr roboto" && i%2 != 0
					current_move = roboto_move(current_game, current_game.example_array,i)
					valid_move = "y"
				elsif current_game.player2.name == "mr roboto" && i%2 == 0
					current_move = roboto_move(current_game, current_game.example_array,i)
					valid_move = "y"
				else
					puts "What's your move? (1 - 9)"

					current_move = gets.chomp
					puts "Invalid move, try again" unless current_game.example_array.include? current_move
					valid_move = "y" if current_game.example_array.include? current_move
				end
			end
			current_game.move(current_game.player1, current_move) if i%2 != 0
			current_game.move(current_game.player2, current_move) if i%2 == 0
			i += 1
		end
		puts "NO WINNERS, you are both losers" if current_game.won == 0
		in_game = "n"
	end


	again = "y"
	while again == "y"
		puts "Do you want to play again? (y/n)"
		keep_playing = gets.chomp.downcase
		if keep_playing == "n" || keep_playing == "y"
			again = "n"
			next
		end
		puts "You need to choose 'y' or 'n'"
	end
end