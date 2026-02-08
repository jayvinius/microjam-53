extends Node2D

signal intro_finished

@export var text: Array[String]
@export var text_idx: int = -1:
	set(new_val):
		text_idx = new_val
		if text_idx < text.size():
			%SpeachBubble.text = text[text_idx]

@export var active: bool = false:
	set(new_val):
		active = new_val
		if active:
			text_idx = 0

# func _ready() -> void:
# 	text_idx = 0

func _process(_delta: float) -> void:
	if !active: return
	if Input.is_action_just_pressed("reel_in"):
		text_idx += 1
		if text_idx == text.size():
			intro_finished.emit()
			queue_free()
