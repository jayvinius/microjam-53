extends Node2D

@export var fish: String:
	set(new_fish):
		fish = new_fish
		%SpeachBubble.text = "Oh cool, I got a %s!" % fish

@export var speach_bubble: SpeachBubble

func _ready() -> void:
	speach_bubble = %SpeachBubble

func special(text) -> void:
	%SpeachBubble.text = text
