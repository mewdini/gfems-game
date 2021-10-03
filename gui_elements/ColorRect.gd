extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	var mm_visible = parent.map_visible
	var minimap = parent.get_node("MiniMap")
	if mm_visible:
		visible = true
		rect_size.x = minimap.rect_size.x + 10
		rect_size.y = minimap.rect_size.y + 10
