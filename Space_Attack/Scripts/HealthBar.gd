extends ProgressBar

onready var player = get_parent().get_node("Player")

func _ready():
	min_value = 0
	max_value = player.health
	value = player.health

func _on_Player_get_damage():
	value = player.health
