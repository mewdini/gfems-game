extends Path2D

onready var follow = get_node("PathFollow2D")
onready var rival_sprite = get_node("PathFollow2D/AnimatedSprite")

var PATH_DURATION = 6 # seconds
var tween

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(follow, "unit_offset",
								0, 1, PATH_DURATION,
								tween.TRANS_LINEAR,
								tween.EASE_IN_OUT)
	tween.set_repeat(true)
	tween.start()

var pos
var diff
var old_pos = Vector2(0,0)

func _process(delta):
	pos = rival_sprite.get_global_position().floor()
	diff = pos - old_pos
	if diff.x > 0:
		rival_sprite.play("right")
	elif diff.x < 0:
		rival_sprite.play("left")
	elif diff.y < 0:
		rival_sprite.play("up")
	else:
		rival_sprite.play("down")
	old_pos = pos
