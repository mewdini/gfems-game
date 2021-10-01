extends Node2D

func _ready():
	if PlayerData.last_door_entered == "town_to_home":
		var player = get_node("YSort/Player")
		player.position.x = 888
		player.position.y = 1032
		player.start_animation = "idle_up"

# make this the room where you have to learn all the controls
# WASD to walk
# E to talk to your spouse
# ZXCV to select dialogue options
# make a hint panel to describe this seperately from the dialogue
