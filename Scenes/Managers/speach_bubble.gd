extends Node2D

@export var text: String:
	set(new_text):
		text = new_text
		%RichTextLabel.text = text
		%RichTextLabel.visible_ratio = 0
		displaying_text = true

var displaying_text: bool = false

func _process(delta: float) -> void:
	if displaying_text:
		if %RichTextLabel.visible_ratio >= 1:
			displaying_text = false
			return
		%RichTextLabel.visible_ratio += delta/2.0
		if !%AudioStreamPlayer2D.playing:
			%AudioStreamPlayer2D.play()
