extends KinematicBody2D

export (int) var speed = 500
export (int) var detection_range = 52
export var start_animation = "idle_right" setget set_start_anim

var velocity: Vector2
var player_name = "Julia" # TODO add section where player inputs name at start of game
var target  #= $RayCast2D.get_collider()


onready var tool_tip: Label = get_node("../UserInterface/UserInterface/ToolTipLabel")

func set_start_anim(anim):
	start_animation = anim
	$AnimatedSprite.play(anim)

func _on_ready():
	$AnimatedSprite.play(start_animation)

func get_input():
	# NPC Interaction
	if Input.is_action_pressed("ui_select"):
		
		
		if target != null:
			# Talk to NPC
			target.talk()
			return
		else:
			tool_tip.visible = false

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
	
	# Apply movementasaw
	var movement = speed * direction * delta
	move_and_collide(movement)
	
	# Update player animation
	animation_manager(direction)
	
	# Turn RayCast2D toward movement direction
	if direction != Vector2.ZERO:
		$RayCast2D.cast_to = direction.normalized() * detection_range
		
	target = $RayCast2D.get_collider()
	if target:
		tool_tip.visible = true
	else:
		tool_tip.visible= false
		print(tool_tip)
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
				
func update_currency(amount: int):
	PlayerData.currency += amount
