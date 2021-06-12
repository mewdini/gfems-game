extends Node2D

onready var player = get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	var door = PlayerData.last_door_entered
	if  door == "gov_to_town":
		set_player_loc(3230, 2220, "idle_down")
	elif door == "home_to_town":
		set_player_loc(655, 1296, "idle_down")
	elif door == "broker1_to_town":
		set_player_loc(297, 3531, "idle_down")
	elif door == "broker2_to_town":
		set_player_loc(498, 4314, "idle_down")
	elif door == "broker3_to_town":
		set_player_loc(1801, 3852, "idle_down")

# deal with player location
func set_player_loc(x, y, animation):
	player.position.x = x
	player.position.y = y
	player.start_animation = animation
