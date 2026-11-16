extends Control


func _ready() -> void:
	visible = false
	# Keep the restart button working while the game is paused.
	process_mode = Node.PROCESS_MODE_ALWAYS


func show_game_over() -> void:
	visible = true
	get_tree().paused = true


func _on_start_game_pressed() -> void:
	visible = false
	Global.lives = Global.max_lives
	get_tree().paused = false
	get_tree().reload_current_scene()
