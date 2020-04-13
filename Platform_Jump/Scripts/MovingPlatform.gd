extends Path2D

export var speed = 250

onready var follow = $Follow
onready var platform = $Follow/Platform

var direction = 1
var sprite_half_width

func _ready():
	randomize()
	direction = 1 if rand_range(1 , 500) > 50 else -1
	sprite_half_width = platform.sprite_half_width

func _process(delta):
	follow.offset += speed * direction * delta
	if direction > 0 and follow.unit_offset > 0.99:
		direction = -1
	elif direction < 0 and follow.unit_offset < 0.01:
		direction = 1
