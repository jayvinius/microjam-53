extends Node2D

@export var fish: Fish:
	set(new_fish):
		fish = new_fish
		%SpeachBubble.text = "Oh cool, I got a %s!" % fish.name
