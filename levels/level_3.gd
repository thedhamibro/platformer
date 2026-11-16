extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_start_game_detection_3_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().change_scene_to_file("res://levels/level_4.tscn")
