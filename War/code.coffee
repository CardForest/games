# add a new shuffled standard deck to the game scope
# the deck will be accessible via game.deck
game.createDeck().shuffle()

# add 2 new card piles to each player
for p in [player, opponent]
	p.createPile   name: 'down'
	p.createPile   name: 'battle'

# dealing just 10 cards to each player
	game.deck.moveTo(p.down,10)

# dealing all cards from deck to each player
# it's commented out because it's not fun to play the all deck...
#deal
#	from: game.deck
#	to: [player.down, opponent.down]

mainGameLoop = ->
	# wait until every player perform the "battle!" action
	action 'Battle!', ->
		# move the top card from each player down pile to battle pile
		for p in [player, opponent]
			p.down.top().flip()
			p.down.moveTo(p.battle, 1)		
		# check if we have a war
		while (pV=player.battle.top().value.rank) is (oV=opponent.battle.top().value.rank) 
			for p in [player, opponent]
				# end the game if one of the player don't have enough cards for war
				if p.down.size() < 4 then return "end"
				# move 3 faced-down and 1 face-up card to the battle pile
				p.down.moveTo(p.battle, 3)
				p.down.top().flip()
				p.down.moveTo(p.battle, 1)
		# determine the winner of the battle		
		[battleWinner, battleLoser] = if pV > oV then [player, opponent] else [opponent, player]
		# end the game if the loser don't have any more cards
		if battleLoser.down.isEmpty() then return "end"
		# move the battle cards to the winner
		battleLoser.battle.moveTo(battleWinner.battle, battleLoser.battle.size())
		battleWinner.battle.flipDown().shuffle().moveTo(battleWinner.down, battleWinner.battle.size())

		mainGameLoop()

mainGameLoop()