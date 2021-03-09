extends Sprite

var char_tex = load("res://sprites/red/redDown.png")

func _ready():
	set_process_input(true)
	texture = char_tex

func _input(event):
	if event is InputEventKey:
		if Input.is_action_pressed("ui_up"):
			texture = load("res://sprites/red/redUp.png")
		elif Input.is_action_pressed("ui_down"):
			texture = load("res://sprites/red/redDown.png")
		elif Input.is_action_pressed("ui_left"):
			texture = load("res://sprites/red/redLeft.png")
		elif Input.is_action_pressed("ui_right"):
			texture = load("res://sprites/red/redRight.png")
