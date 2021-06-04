extends KinematicBody2D

export (int) var speed = 500
export (int) var detection_range = 52

var velocity: Vector2
var player_name = "Pablo" # TODO add section where player inputs name at start of game

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
	var direction: Vector2
	if !get_tree().paused:	
		# Get player input
		
		direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	else:
		direction = Vector2.ZERO
		
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	# Apply movement
	var movement = speed * direction * delta
	move_and_collide(movement)
	
	# Update player animation
	animation_manager(direction)
	
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
	elif dir == Vector2.ZERO:
		match $AnimatedSprite.animation:
			"run_right":
				$AnimatedSprite.play("idle_right")
			"run_left":
				$AnimatedSprite.play("idle_left")
			"run_up":
				$AnimatedSprite.play("idle_up")
			"run_down":
				$AnimatedSprite.play("idle_down")
