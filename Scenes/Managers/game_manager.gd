extends Node2D

@export var current_fish: Fish
@export var max_stamina: float = 30.0
var stamina: float:
	set(new_stamina):
		stamina = new_stamina
		%TempStaminaBar.text = str(stamina)
var should_regen_stamina := false

var casted := false

func _ready() -> void:
	stamina = max_stamina

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reel_in") and stamina > 0:
		if not casted:
			casted = true
		if current_fish:
			current_fish.position.y -= 100/abs(current_fish.position.x)
			stamina -= 1
			should_regen_stamina = false
			%StaminaRegenTimer.start()
			if current_fish.position.y < 0:
				print("you caught a fish")
				current_fish = null
				casted = false

	regen_stamina()

func _physics_process(delta: float) -> void:
	queue_redraw()

func _on_stamina_regen_timer_timeout() -> void:
	print("here")
	should_regen_stamina = true

func regen_stamina() -> void:
	if !should_regen_stamina: return
	stamina = lerp(stamina, max_stamina, .05)

func _draw() -> void:
	if not casted: return
	# TODO: Add more rod things, and make this give the player more feedback on where the fish is
	draw_line(%Player.position, Vector2(0, 0), Color.WEB_GRAY, 1.0)
	if current_fish:
		draw_line(Vector2(0, 0), current_fish.position, Color.WEB_GRAY, 1.0)
	else:
		draw_line(Vector2(0, 0), Vector2(0, 100), Color.WEB_GRAY, 1.0)


func _on_area_2d_body_entered(body: Node2D) -> void:
	# Get a new fish if there's no fish hooked and is casted
	if not body is Fish or current_fish != null or not casted: return
	current_fish = body
