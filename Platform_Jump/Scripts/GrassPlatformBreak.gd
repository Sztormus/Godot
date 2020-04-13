extends Area2D

onready var sprite = $Sprite
onready var collision = $Collision
onready var particles = $Particles
onready var audio = $Audio

var sprite_half_width

func _ready():
	sprite_half_width = sprite.texture.get_width() / 2
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "Player" and !body.jumping:
		if body.position.y < position.y:
			body.jump()
			sprite.queue_free()
			collision.queue_free()
			particles.emitting = true
			audio.play()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
