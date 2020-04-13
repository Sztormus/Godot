extends Node

const MIN_INTERVAl = 100
const MAX_INTERVAL = 250
const INITIAL_INTERVAL_COUNT = 40
const SPECIAL_PLATFORM_CHANCE = 20

onready var player = $Player
onready var score_text = $UI/Score

export(Array) var platforms
export(Array) var special_platforms

var current_max_interval
var current_min_interval
var last_spawn_height
var screen_size

func _ready():
	last_spawn_height = get_viewport().get_visible_rect().size.y
	screen_size = get_viewport().get_visible_rect().size.x
	current_max_interval = MIN_INTERVAl
	current_min_interval = MIN_INTERVAl
	_spawn_first_platforms()

func _process(delta):
	score_text.text = str(player.score)

func _spawn_platform():
	randomize()
	var new_platform
	var index = rand_range(0, platforms.size())
	if rand_range(0, 100) > 100 - SPECIAL_PLATFORM_CHANCE:
		index = rand_range(0, special_platforms.size())
		new_platform = special_platforms[index].instance()
	else:
		index = rand_range(0, platforms.size())
		new_platform = platforms[index].instance()
	add_child(new_platform)
	var spawn_x = rand_range(0 + new_platform.sprite_half_width, screen_size - new_platform.sprite_half_width)
	var spawn_position = Vector2(spawn_x, last_spawn_height)
	new_platform.position = spawn_position
	last_spawn_height -= rand_range(current_min_interval, current_max_interval)
	current_min_interval += 5
	current_max_interval += 7.5
	current_max_interval = clamp(current_max_interval, MIN_INTERVAl, MAX_INTERVAL)

func _spawn_first_platforms():
	for counter in range(INITIAL_INTERVAL_COUNT):
		_spawn_platform()

func _on_Player_just_jumped():
	for counter in range(3):
		_spawn_platform()
