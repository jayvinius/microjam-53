extends Node2D

@export var current_fish: Fish
@export var max_stamina: float = 30.0
var stamina: float:
	set(new_stamina):
		stamina = new_stamina
		%TempStaminaBar.text = str(stamina)
var should_regen_stamina := false

func _ready() -> void:
	stamina = max_stamina

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reel_in") and stamina > 0:
		current_fish.position.y -= 100/abs(current_fish.position.x)
		stamina -= 1
		should_regen_stamina = false
		%StaminaRegenTimer.start()

	regen_stamina()

func _on_stamina_regen_timer_timeout() -> void:
	print("here")
	should_regen_stamina = true

func regen_stamina() -> void:
	if !should_regen_stamina: return
	stamina = lerp(stamina, max_stamina, .5)
