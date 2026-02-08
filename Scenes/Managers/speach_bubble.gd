extends Node2D
class_name SpeachBubble

@export var text: String:
	set(new_text):
		text = new_text
		%RichTextLabel.text = text
		%RichTextLabel.visible_ratio = 0
		prev_sound_char = 0
		displaying_text = true

@export var displaying_text: bool = false

var prev_sound_char: int = 0

func _process(delta: float) -> void:
	if displaying_text:
		if %RichTextLabel.visible_ratio >= 1:
			displaying_text = false
			return
		%RichTextLabel.visible_ratio += delta/2.0
		if %RichTextLabel.visible_characters > prev_sound_char + randi_range(0, 2):
			%AudioStreamPlayer2D.play()
			prev_sound_char = %RichTextLabel.visible_characters
