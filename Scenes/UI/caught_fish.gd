extends Control

@export var fish: Fish:
	set(new_fish):
		fish = new_fish
		%Label.text = "You caught a %s\n(E)at or (U)se as Bait" % fish.name
