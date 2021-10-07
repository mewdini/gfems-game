extends Sprite

var mm: TextureRect
var player: KinematicBody2D
var b: Vector2

func _ready():
	mm = get_parent()
	player = get_tree().get_root().find_node("Player", true, false)
	# determine visibility
	visible = mm.get_parent().map_visible
	# set size to 1/15th of map
	var w = texture.get_width()
	var h = texture.get_height()
	# make size of sprite 1/20th that of rect_size
	scale.x = (mm.rect_size.x / float(20)) / w
	scale.y = scale.x
	# center in minimap
	position.x = mm.rect_size.x / float(2)
	position.y = mm.rect_size.y / float(2)
	# default direction
	b = Vector2(0,1)

# credit: https://stackoverflow.com/questions/14066933/direct-way-of-computing-clockwise-angle-between-2-vectors
func _process(delta):
	# rotate pointer to direction walking
	var a = Vector2(0, -1)
	if player.direction:
		b = player.direction
	var dot_prod = a.dot(b)
	var det = a.x * b.y - b.x * a.y
	rotation_degrees = rad2deg(atan2(det, dot_prod))
