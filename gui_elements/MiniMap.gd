extends TextureRect

export var zoom_out: float
var player: KinematicBody2D
var mm_cropped: AtlasTexture
onready var mm_visible = get_parent().map_visible

# Make texture of full minimap
var mm_texture: Texture = preload("res://assets/town_map.png")

func _ready():
	if mm_visible:
		# scale the texture to fit the node's bounding rectangle, but maintain the texture's aspect ratio.
		set_stretch_mode(STRETCH_KEEP_ASPECT)
		set_expand(true)
		# init atlas
		mm_cropped = AtlasTexture.new()
		mm_cropped.set_atlas(mm_texture)
		player = get_tree().get_root().find_node("Player", true, false)
	
func _process(delta):
	if mm_visible:
		var width = zoom_out
		var height = zoom_out * float(2)/3
		# get player coordinates
		var player_pos: Vector2 = player.global_position
		# find relative minimap coordinates
		var mini_pos: Vector2 = player_pos / 5
		# center player on minimap
		mini_pos.x -= width/2
		mini_pos.y -= height/2
		# make rectangle based on player (center) coordinates
		var view_rect: Rect2 = Rect2(mini_pos.x, mini_pos.y, width, height)
		
		# TODO offset so coordinates are not outside of minimap bounds
		# make atlastexture from rectangle and texture
		mm_cropped.set_region(view_rect)
		
		# draw texture on this node
		set_texture(mm_cropped)
