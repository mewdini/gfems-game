extends TextureRect

onready var player: KinematicBody2D = find_node("Player")
func _update():
	# get player coordinates
	var player_pos: Vector2 = player.global_position
	# find relative minimap coordinates
	var mini_pos: Vector2 = player_pos / 5
	# make rectangle based on player (center) coordinates
	var width = 5 # TODO decide zoom level
	var height = 5 # TODO decide zoom level
	var view_rect: Rect2 = Rect2(mini_pos.x, mini_pos.y, width, height)
	# TODO offset so coordinates are not outside of minimap bounds
	# make texture from rectangle and image
	# draw texture on this node
	pass
