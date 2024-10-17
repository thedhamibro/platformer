extends Node

@onready var score = $Score
var score_val = 0

func add_point():
	score_val += 1
	score.text = "You have collected " + str(score_val) + " coins!"
	
