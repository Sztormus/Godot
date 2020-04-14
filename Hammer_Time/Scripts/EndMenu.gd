extends Node

onready var score = $Score

var score_amount = 0

func _ready():
	score.bbcode_text = "[center]" + str(score_amount) + "[/center]"

func _on_Button_pressed():
	$"/root/LevelManager".change_scene("Game")
