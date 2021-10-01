extends TextureRect

onready var player: KinematicBody2D = find_node("Player")
func _update():
	# get player coordinates
	var player_pos: Vector2 = player.global_position
	# find relative minimap coordinates
	# make rectangle based on player (center) coordinates
	# offset so coordinates are not outside of minimap bounds
	# make texture from rectangle and image
	# draw texture on this
	pass
