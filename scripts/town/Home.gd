extends Node2D


func _ready():
	if PlayerData.last_door_entered == "town_to_home":
		var player = get_node("Player")
		player.position.x = 888
		player.position.y = 1032
		player.start_animation = "idle_up"
