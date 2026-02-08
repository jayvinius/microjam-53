extends Node2D

@export var game_manager: Node

func _draw() -> void:
	if not game_manager.casted: return
	# TODO: Add more rod things, and make this give the player more feedback on where the fish is
	if game_manager.current_fish:
		var offset :float = game_manager.current_fish.position.x / 6.0
		offset = clamp(offset, -10.0, 10.0)
		draw_line(%RodTip.global_position, Vector2(%Hole.position.x + offset, %Hole.position.y), Color.WEB_GRAY, 1.0)
		draw_line(Vector2(%Hole.position.x + offset, %Hole.position.y), game_manager.current_fish.position, Color.WEB_GRAY, 1.0)
	else:
		draw_line(%RodTip.global_position, %Hole.position, Color.WEB_GRAY, 1.0)
		draw_line(%Hole.position, Vector2(0, 100), Color.WEB_GRAY, 1.0)

func _physics_process(delta: float) -> void:
	queue_redraw()
