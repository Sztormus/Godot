extends Area

onready var animation = $Animation

var is_nail_hit

signal nail_hit
signal game_end

func _ready():
	connect("area_entered", self, "_on_area_entered")

func _input(event):
	if (event is InputEventMouseButton or InputEventScreenTouch) and event.is_pressed():
		animation.play("hit")

func _on_area_entered(area):
	if area.is_in_group("Nails"):
		if area.already_hit:
			emit_signal("game_end")
			return
		is_nail_hit = true
		area.already_hit = true
		emit_signal("nail_hit")
	elif area.is_in_group("Bombs"):
		emit_signal("game_end")

func check_nail_hit():
	if !is_nail_hit:
		emit_signal("game_end")
	is_nail_hit = false
