extends Node2D

onready var player = get_node("YSort/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	var door = PlayerData.last_door_entered
	var last_loc = PlayerData.last_location
	var scene = get_tree().current_scene.filename.to_lower()
	if scene in last_loc:
		var scene_loc = last_loc[scene]
		set_player_loc(scene_loc.x, scene_loc.y - 20, "idle_up")

# deal with player location
func set_player_loc(x, y, animation):
	player.position.x = x
	player.position.y = y
	PlayerData.start_animation = animation
