extends KinematicBody2D

const WALK_SPEED = 200

var velocity = Vector2()

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
	else:
		velocity.x = 0
	if Input.is_action_pressed("ui_up"):
		velocity.y = -WALK_SPEED
	elif Input.is_action_pressed("ui_down"):
		velocity.y = WALK_SPEED
	else:
		velocity.y = 0
		
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "mew":
			get_node("../Camera2D/message").show()

	# We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.

	# The second parameter of "move_and_slide" is the normal pointing up.
	# In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
	move_and_slide(velocity, Vector2(0, -1))
