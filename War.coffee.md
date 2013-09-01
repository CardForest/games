
War
---

> Adapted from [Wikipedia][].

**_War_** is a [card game][] typically involving two players.
It uses a standard [French playing card deck][].
Due to its simplicity, it is played most often by children.

```coffee
# add a new shuffled standard deck to the game scope
# the deck will be accessible via game.deck
game.createDeck().shuffle()
```

### Gameplay

#### Deal

The deck is divided evenly among the two players, giving each a down stack.
In unison, each player reveals the top card of their deck - this is called, a **_battle_**.

```coffee
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
```

#### Battle

The player with the higher card takes both the cards played and moves them to the bottom of their stack.

If the two cards played are of equal value, then there is a **_war_**:

- Both players play the next 3 cards of their pile face down and then another (4th) card face-up.
- The owner of the higher face-up card wins the war and adds all 10 cards on the table to the bottom of their deck.
- If the face-up cards are again equal then the battle repeats.

#### Ending

If a player runs out of cards after a battle or during a war that player immediately loses.

```coffee
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
```

### Metadata

The game is played by two players

```INI
number of players = 2
```

### Layout

The player's piles are on the left and the opponent piles are on the right.
I the middle there is a button that triggers the battle action.

```HTML
<div class="container">
	<div class="row">
		<div class="col-5">
			<pile container="player" name="battle" />
		</div>
		<div class="col-2">
			<action name="Battle!" />
		</div>
		<div class="col-5">
			<pile class="pull-right" container="opponent" name="battle" />
		</div>
	</div>
	<br/>
	<div class="row">
		<div class="col-5">
			<pile container="player" name="down" />
		</div>
		<div class="col-7">
			<pile class="pull-right" container="opponent" name="down" />
		</div>
	</div>
</div>
```

### See also

* [Beggar-your-neighbor](http://en.wikipedia.org/wiki/Beggar-your-neighbor)
* [Slapjack](http://en.wikipedia.org/wiki/Slapjack)
* [Egyptian Ratscrew](http://en.wikipedia.org/wiki/Egyptian_Ratscrew)
* [Snip Snap Snorem](http://en.wikipedia.org/wiki/Snip_Snap_Snorem)

[Wikipedia]: http://en.wikipedia.org/wiki/War_%28card_game%29
[card game]: http://en.wikipedia.org/wiki/Card_game
[French playing card deck]: http://en.wikipedia.org/wiki/Playing_card#French_design

