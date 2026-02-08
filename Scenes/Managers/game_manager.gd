extends Node2D

@export var current_fish: Fish
@export var max_stamina: float = 30.0:
	set(new_max_stamina):
		max_stamina = new_max_stamina
		%StaminaBarBar.max_value = max_stamina
var stamina: float:
	set(new_stamina):
		stamina = new_stamina
		%StaminaBarBar.value = stamina
var should_regen_stamina := false

var hunger: float = 10.0:
	set(new_hunger):
		hunger = new_hunger
		%TempHungerBar.text = str(hunger)

var casted := false

var caught_fish: Fish
@export var caught_fish_scene: PackedScene
var caught_state: bool = false

func _ready() -> void:
	stamina = max_stamina
	%StaminaBarBar.max_value = max_stamina

func _process(delta: float) -> void:
	regen_stamina()

	if caught_state:
		if Input.is_action_just_pressed("eat"):
			hunger += caught_fish.size
			caught_fish = null
			caught_state = false
			%CaughtFish.hide()
		elif Input.is_action_just_pressed("use"):
			caught_state = false
			%CaughtFish.hide()
		return

	if Input.is_action_just_pressed("reel_in") and stamina > 0:
		if not casted:
			casted = true
		if current_fish:
			current_fish.position.y -= 100/abs(current_fish.position.x)
			stamina -= 1
			should_regen_stamina = false
			%StaminaRegenTimer.start()
			if current_fish.position.y < %Hole.position.y:
				caught_fish = current_fish
				%CaughtFish.fish = caught_fish
				%CaughtFish.show()
				caught_state = true
				current_fish = null
				casted = false


func _physics_process(delta: float) -> void:
	queue_redraw()
	# Temp hunger decrease constantly
	hunger -= delta
	if hunger < 0:
		print("damn, shit's hungering")

func _on_stamina_regen_timer_timeout() -> void:
	should_regen_stamina = true

func regen_stamina() -> void:
	if !should_regen_stamina: return
	stamina = lerp(stamina, max_stamina, .05)

func _draw() -> void:
	if not casted: return
	# TODO: Add more rod things, and make this give the player more feedback on where the fish is
	if current_fish:
		var offset := current_fish.position.x / 6.0
		offset = clamp(offset, -10.0, 10.0)
		draw_line(%RodTip.global_position, Vector2(%Hole.position.x + offset, %Hole.position.y), Color.WEB_GRAY, 1.0)
		draw_line(Vector2(%Hole.position.x + offset, %Hole.position.y), current_fish.position, Color.WEB_GRAY, 1.0)
	else:
		draw_line(%RodTip.global_position, %Hole.position, Color.WEB_GRAY, 1.0)
		draw_line(%Hole.position, Vector2(0, 100), Color.WEB_GRAY, 1.0)


func _on_area_2d_body_entered(body: Node2D) -> void:
	# Get a new fish if there's no fish hooked and is casted
	if not body is Fish or current_fish != null or not casted: return
	current_fish = body
