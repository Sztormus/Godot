extends KinematicBody2D

const SPEED = 500

onready var sprite = $Sprite
onready var timer = $Timer
onready var deathtimer = $DeathTimer
onready var audio = $Audio

export(PackedScene) var projectile
export var health = 100

var screen_size
var half_sprite_size
var can_shoot = true
var dead = false

signal get_damage

func _ready():
	screen_size = get_viewport_rect().size.x
	half_sprite_size = sprite.texture.get_width() / 2 * scale.x

func _process(delta):
	if Input.is_action_pressed("left"):
		if position.x >= half_sprite_size:
			position.x -= SPEED * delta
	elif Input.is_action_pressed("right"):
		if position.x < screen_size - half_sprite_size:
			position.x += SPEED * delta
	if can_shoot and Input.is_action_pressed("shoot"):
		can_shoot = false
		var new_projectile = projectile.instance()
		get_parent().add_child(new_projectile)
		new_projectile.position = position
		timer.start()
		audio.play()

func _on_Timer_timeout():
	can_shoot = true

func add_damage(damage):
	if dead:
		return
	health -= damage
	emit_signal("get_damage")
	if health <= 0:
		dead = true
		health = 0
		deathtimer.start()
		set_process(false)
		sprite.queue_free()


func _on_DeathTimer_timeout():
	get_tree().reload_current_scene()
