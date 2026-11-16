extends Control


func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	pass




func _on_start_game_pressed() -> void:
	visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()
