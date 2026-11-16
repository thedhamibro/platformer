extends Node

var score = 0
var coins = 0
var max_lives = 3
var lives = max_lives
@onready var coin: Label = $GUI/Coin/Coin

func _process(delta: float) -> void:
	coin.text = str(coins)
