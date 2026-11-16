extends Node

var score = 0
var coins = 0
@onready var coin_label: Label = $GUI/Coin/Coin
@onready var score_label: Label = $GUI/Score


func _process(_delta: float) -> void:
	coin_label.text = str(coins)
	score_label.text = "Score: %d" % score
