extends KinematicBody2D

export (int) var speed = 500
export (int) var detection_range = 52
export var start_animation = "idle_right" #setget set_start_anim

var velocity: Vector2
onready var player_name = PlayerData.get_char_name()
onready var sprite = PlayerData.get_sprite()
var target  #= $RayCast2D.get_collider()
var anim_sprite: AnimatedSprite


onready var tool_tip: Label = get_node("../../UserInterface/UserInterface/ToolTipLabel")

#func set_start_anim(anim):
#	start_animation = anim
#	anim_sprite.play(anim)

func _ready():
	# get selected sprite
	var sprite_enum = PlayerData.Sprite_Name.values()[PlayerData.get_sprite()]
	if sprite_enum == PlayerData.Sprite_Name.DAN:
		anim_sprite = $AnimatedSprites/DanAnimatedSprite
	elif sprite_enum == PlayerData.Sprite_Name.AMELIA:
		anim_sprite = $AnimatedSprites/AmeliaAnimatedSprite
	anim_sprite.set_visible(true)
	
	for i in $AnimatedSprites.get_children():
		if i != anim_sprite:
			i.queue_free()
	
	anim_sprite.play(PlayerData.start_animation)

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
	print(self.position.x, " ", self.position.y)
	get_input()
	
func animation_manager(dir):
	if dir.x == 1:
		anim_sprite.play("run_right")
	elif dir.x == -1:
		anim_sprite.play("run_left")
	elif dir.y == 1:
		anim_sprite.play("run_down")
	elif dir.y == -1:
		anim_sprite.play("run_up")
	elif dir == Vector2.ZERO:
		match anim_sprite.animation:
			"run_right":
				anim_sprite.play("idle_right")
			"run_left":
				anim_sprite.play("idle_left")
			"run_up":
				anim_sprite.play("idle_up")
			"run_down":
				anim_sprite.play("idle_down")
				
func update_currency(amount: int):
	PlayerData.currency += amount
