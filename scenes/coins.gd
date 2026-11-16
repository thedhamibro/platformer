extends AnimatedSprite2D

@onready var player: CharacterBody2D = $"../player"
@onready var node: Node = $"../GameManager"
@onready var node2: Node = $"../../GameManager"

func _ready() -> void:
	if player == null:
		player = $"../../player"
	elif player == null:
		player = $player
		
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		var game_manager = node if node != null else node2
		if game_manager != null:
			game_manager.coins += 1
			game_manager.score += 100
			queue_free()
