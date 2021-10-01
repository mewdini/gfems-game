extends TextureRect

export var zoom_out: float  
onready var player: KinematicBody2D = find_node("Player")
# TODO make texture from full image
func _update():
	# get player coordinates
	var player_pos: Vector2 = player.global_position
	# find relative minimap coordinates
	var mini_pos: Vector2 = player_pos / 5
	# make rectangle based on player (center) coordinates
	var width = zoom_out
	var height = zoom_out
	var view_rect: Rect2 = Rect2(mini_pos.x, mini_pos.y, width, height)
	# TODO offset so coordinates are not outside of minimap bounds
	# make atlastexture from rectangle and texture
	#
	# draw texture on this node
	# self.set_value(texture)
