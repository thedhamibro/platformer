extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func resume():
	print("Resuming...")
	get_tree().paused = false
	if animation_player.has_animation("blur"):  # Check animation exists
		animation_player.play_backwards("blur")
	else:
		print("Animation 'blur' not found")

func pause():
	print("Pausing...")  # Debug message
	get_tree().paused = true
	if animation_player.has_animation("blur"):
		animation_player.play("blur")
	else:
		print("Animation 'blur' not found")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
