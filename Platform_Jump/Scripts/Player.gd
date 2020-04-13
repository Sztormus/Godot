extends KinematicBody2D

onready var animated_sprite = $AnimatedSprite
onready var audio = $Audio

const JUMP_SOUND_PATH = "res://audio/jump.wav"
const IMPULSE_SOUND_PATH = "res://audio/impulse.wav"
const GRAVITY = 1500
const GRAVITY_INCREMENT = 2500
const JUMP_DECREMENT = 100
const JUMP_FORCE = 40

export var speed = 500

var screen_width
var half_sprite_width
var score
var jump_audio
var impulse_audio

var jumping = false
var current_jump_force = 0
var current_gravity = 0
var heighest_reached_position = 300
var death_position_offset = 1200

signal just_jumped

func _ready():
	score = abs(heighest_reached_position) - 300
	screen_width = get_viewport_rect().size.x
	half_sprite_width = animated_sprite.frames.get_frame("idle", 0).get_width() / 2
	current_gravity = GRAVITY
	jump_audio = load(JUMP_SOUND_PATH)
	impulse_audio = load(IMPULSE_SOUND_PATH)

func _process(delta):
	if !jumping:
		_increment_gravity(delta)
		position.y += current_gravity * delta
	else:
		position.y -= current_jump_force
		_decrement_jump(delta)
	
	heighest_reached_position = position.y if position.y < heighest_reached_position else heighest_reached_position
	score = int(abs(heighest_reached_position) - 300)
	score = score if score > 0 else 0
	if position.y >= heighest_reached_position + death_position_offset:
		die()
	
	if Input.is_action_pressed("ui_left"):
		position.x -= speed * delta
	elif Input.is_action_pressed("ui_right"):
		position.x += speed * delta
	elif Input.is_action_pressed("ui_accept"):
		jump()
	
	_check_boundaries()

func jump():
	if jumping:
		return
	current_gravity = 0
	jumping = true
	current_jump_force = JUMP_FORCE
	animated_sprite.play("jump")
	emit_signal("just_jumped")
	audio.stream = jump_audio
	audio.play()

func add_impulse(impulse):
	emit_signal("just_jumped")
	current_gravity = 0
	jumping = true
	current_jump_force = impulse
	animated_sprite.play("jump")
	audio.stream = impulse_audio
	audio.play()

func die():
	$"/root/PlayerData".save_highscore(score)
	$"/root/LevelManager".change_scene("Menu")

func _increment_gravity(delta):
	current_gravity += GRAVITY_INCREMENT * delta
	if current_gravity >= GRAVITY:
		current_gravity = GRAVITY

func _decrement_jump(delta):
	current_jump_force -= JUMP_DECREMENT * delta
	if current_jump_force <= 0:
		current_jump_force = 0
		jumping = false
		animated_sprite.play("idle")

func _check_boundaries():
	if position.x > screen_width:
		position.x = 0
	elif position.x < 0:
		position.x = screen_width
