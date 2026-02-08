extends Node2D

@export var dropped_fish_sound: AudioStream
@export var caught_fish_sound: AudioStream

@export var current_fish: Fish:
	set(new_val):
		current_fish = new_val
		if current_fish:
			%Player.texture = player_sprites[1]
			%RodTip.position = Vector2(31, -24)
			%StaminaBar.show()
		else:
			%Player.texture = player_sprites[0]
			%RodTip.position = Vector2(30, -31)
			%StaminaBar.hide()

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

@export var player_sprites: Array[Texture2D]

var playing_intro = true

var camera_y_target = -72.0
var panned = false
var starting_game = true
var started_game = false

func _ready() -> void:
	stamina = max_stamina
	%StaminaBarBar.max_value = max_stamina
	%IntroTalk.connect("intro_finished", Callable(self, "_intro_finished"))
	%IntroTalk.active = false
	for fish_type in fish_types:
		var temp = fish_type.instantiate()
		fish_type_caught[temp.fish_name] = 0
	%EndTalk.connect("intro_finished", Callable(self, "_end_talk_finished"))

func _intro_finished():
	playing_intro = false

func _end_talk_finished():
	end_talk = false

func _process(delta: float) -> void:
	if !panned:
		if Input.is_action_just_pressed("reel_in"):
			panned = true
		return
	if starting_game and !started_game:
		%Camera2D.offset.y = lerp(%Camera2D.offset.y, camera_y_target, delta)
		if %Camera2D.offset.y >= camera_y_target - 2:
			started_game = true
			%IntroTalk.show()
			%IntroTalk.active = true

	if playing_intro:
		return

	if end_talk:
		return

	regen_stamina()

	if caught_state:
		if !%CaughtFish.speach_bubble.displaying_text and Input.is_action_just_pressed("reel_in"):
			caught_state = false
			%CaughtFish.hide()
		return

	if current_fish:
		if abs(current_fish.position.x) > 75:
			%AudioStreamPlayer.stream = dropped_fish_sound
			%AudioStreamPlayer.pitch_scale = randf_range(.9, 1.1)
			%AudioStreamPlayer.play()
			current_fish = null
			casted = false

	if Input.is_action_just_pressed("reel_in") and stamina > 0:
		if not casted:
			casted = true
		if current_fish:
			var strength := 100.0
			if current_fish.position.x > 0:
			# 	# current_fish.position.x -= min(strength/abs(current_fish.position.x), 1)
				current_fish.position.x -= sqrt(current_fish.position.x)
			elif current_fish.position.x < 0:
			# 	# current_fish.position.x += min(strength/abs(current_fish.position.x), 1)
				current_fish.position.x += sqrt(abs(current_fish.position.x))
			current_fish.position.y -= strength/abs(current_fish.position.x)
			stamina -= 1
			should_regen_stamina = false
			%StaminaRegenTimer.start()
			if current_fish.position.y < %Hole.position.y:
				%AudioStreamPlayer.stream = caught_fish_sound
				%AudioStreamPlayer.pitch_scale = randf_range(.9, 1.1)
				%AudioStreamPlayer.play()
				caught_fish = current_fish
				%CaughtFish.fish = caught_fish.fish_name
				if fish_type_caught["Gold Fish"] == 2 and !played_gold:
					played_gold = true
					%CaughtFish.special("COOL! I got three goldfish, I'm feeling inspired to catch an even bigger fish now.")
				if fish_type_caught["Red Fancy"] == 2 and !played_fancy:
					played_fancy = true
					%CaughtFish.special("Nice, I got three fancy fish! I'm feeling a Big Momma in the horizon.")
				%CaughtFish.show()
				caught_state = true
				fish_type_caught[caught_fish.fish_name] += 1
				# Game jam code be like
				if fish_type_caught["Big Mama"] == 1 and !played_mama:
					%CaughtFish.hide()
					end_scene()
				caught_fish.queue_free()
				current_fish = null
				casted = false

var played_gold = false
var played_fancy = false
var played_mama = false

var end_talk = false
func end_scene() -> void:
	played_mama = true
	end_talk = true
	%EndTalk.show()
	%EndTalk.active = true

func _on_stamina_regen_timer_timeout() -> void:
	should_regen_stamina = true

func regen_stamina() -> void:
	if !should_regen_stamina: return
	stamina = lerp(stamina, max_stamina, .05)

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Get a new fish if there's no fish hooked and is casted
	if not body is Fish or current_fish != null or not casted: return

	if body.required_fish and fish_type_caught[body.required_fish_name] > 2:
		current_fish = body
	if !body.required_fish:
		current_fish = body

@export var fish_types: Array[PackedScene]
@export var fish_type_caught: Dictionary

func _on_timer_timeout() -> void:
	match randi_range(0, 12):
		0, 1, 2, 3, 4:
			var new_fish = fish_types[0].instantiate()
			add_child(new_fish)
		5, 6, 7:
			var new_fish = fish_types[1].instantiate()
			add_child(new_fish)
		8, 9:
			var new_fish = fish_types[2].instantiate()
			add_child(new_fish)
