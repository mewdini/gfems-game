extends KinematicBody2D

export (int) var speed = 500
export (float) var time_inside = 3

# pathfinding variables
var velocity = Vector2()
var going_home = true
var inside_timer = 0

# references
var dialoguePopup
var player

var dialogue_state = 0

func _ready():
	dialoguePopup = get_tree().root.get_node("Root/CanvasLayer/DialoguePopup")
	player = get_tree().root.get_node("Root/Player")

# state machine
# check position, then update seen/velocity
func update_velocity(delta):
	velocity = Vector2()
	# check if NPC is inside
	if (!self.visible):
		inside_timer += delta
		if (inside_timer >= time_inside):
			going_home = !going_home
			self.visible = true
			inside_timer = 0
	# update velocity here
	elif (going_home):
		# at door and should move up
		if (self.position.x <= 1839):
			# if at door, disappear and change bool
			if (self.position.y <= 2117):
				self.visible = false
				# TODO find way to pause here
			else:
				velocity.y -= 1
			self.position.x = 1839
		# else not aligned with door
		else:
			# see if should move left or move down
			if (self.position.y >= 2304):
				velocity.x -= 1
				self.position.y = 2304
			else:
				velocity.y += 1
	# if heading in other direction
	else:
		# at door and should move up
		if (self.position.x >= 3111):
			# if at door, disappear and change bool
			if (self.position.y <= 2174):
				self.visible = false
				# TODO find way to pause here
			else:
				velocity.y -= 1
			self.position.x = 3111
		# else not aligned with door
		else:
			# see if should move left or move down
			if (self.position.y >= 2304):
				velocity.x += 1
				self.position.y = 2304
			else:
				velocity.y += 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	update_velocity(delta)
	velocity = move_and_slide(velocity)
	
func talk(answer = ""):
	# Set dialoguePopup npc to Bob
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Bob"
	
	# Show the current dialogue

	match dialogue_state:
		0:
			# Update dialogue tree state
			dialogue_state = 1
			# Show dialogue popup
			dialoguePopup.dialogue = "Hello adventurer! I lost my necklace, can you find it for me?"
			dialoguePopup.answers = "[A] Yes  [B] No"
			dialoguePopup.open()
		1:
			match answer:
				"A":
					# Update dialogue tree state
					dialogue_state = 2
					# Show dialogue popup
					dialoguePopup.dialogue = "Thank you!"
					dialoguePopup.answers = "[A] Bye"
					dialoguePopup.open()
				"B":
					# Update dialogue tree state
					dialogue_state = 3
					# Show dialogue popup
					dialoguePopup.dialogue = "If you change your mind, you'll find me here."
					dialoguePopup.answers = "[A] Bye"
					dialoguePopup.open()
		2:
			# Update dialogue tree state
			dialogue_state = 0
			# Close dialogue popup
			dialoguePopup.close()
		3:
			# Update dialogue tree state
			dialogue_state = 0
			# Close dialogue popup
			dialoguePopup.close()
