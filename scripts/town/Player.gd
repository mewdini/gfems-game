extends KinematicBody2D

export (int) var speed = 500
export (int) var detection_range = 52

var velocity = Vector2()
var player_name = "Pablo" # TODO add section where player inputs name at start of game

var last_dir = Vector2(0,1)

func get_input():
	# NPC Interaction
	if Input.is_action_pressed("ui_select"):
		var target = $RayCast2D.get_collider()
		if target != null:
			if target.is_in_group("NPCs"):
				# Talk to NPC
				target.talk()
				return

func _physics_process(delta):
	# Get player input
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	# Apply movement
	var movement = speed * direction * delta
	move_and_collide(movement)
	
	# Update player animation
	animation_manager(direction)
	
	# Save movement
	if direction != Vector2(0,0):
		last_dir = direction
	
	# Turn RayCast2D toward movement direction
	if direction != Vector2.ZERO:
		$RayCast2D.cast_to = direction.normalized() * detection_range
	
	get_input()
	
func animation_manager(dir):
	if dir.x == 1:
		$AnimatedSprite.play("run_right")
	elif dir.x == -1:
		$AnimatedSprite.play("run_left")
	elif dir.y == 1:
		$AnimatedSprite.play("run_down")
	elif dir.y == -1:
		$AnimatedSprite.play("run_up")
	else:
		if last_dir.x == 1:
			$AnimatedSprite.play("idle_right")
		elif last_dir.x == -1:
			$AnimatedSprite.play("idle_left")
		elif last_dir.y == 1:
			$AnimatedSprite.play("idle_down")
		elif last_dir.y == -1:
			$AnimatedSprite.play("idle_up")
