tool
extends KinematicBody2D
class_name NPC

export (int) var speed = 300
export (String, FILE) var dialogue_file
export (String) var npc_name

# checkpoints are set up as arrays with x, y, delay at point in seconds, and visibility (0 for invisible, 1 for visible)
export (bool) var moves = false
export (Array, int) var checkpoints = [[3075, 2304, 0, 1], [1839, 2304, 0, 1], [1839, 2117, 3, 0], [1839,2304, 0, 1], [3075,2304, 0, 1], [3075,2174, 3, 0]]


# pathfinding variables
var velocity = Vector2()



var current_destination = 0
var current_checkpoint
var pause_timer = 0
var x_dif
var y_dif
var current_check_viz
# references
var dialogue_popup
var player

var dialogue_state = "0"
var state_data

func _get_configuration_warning():
	return "dialogue_file must be set" if dialogue_file == "" else ""

func _ready():
	dialogue_popup = get_tree().root.get_node("Root/DialogueLayer/DialoguePopup")
	player = get_tree().root.get_node("Root/YSort/Player")

# state machine
# check position, then update seen/velocity
func update_velocity(delta):
	velocity = Vector2()

	# get info about current checkpoint and check how far npc is from there
	current_checkpoint = checkpoints[current_destination]
	x_dif = self.position.x - current_checkpoint[0]
	y_dif = self.position.y - current_checkpoint[1]
	if current_checkpoint[3] == 0:
		current_check_viz = false
	else:
		current_check_viz = true

	# uses a 3 pixel fudge factor, as otherwise the velocity can overshoot the destination
	# move in direction of checkpoint
	# could be optimized by using vector math
	if x_dif >= 3:
		velocity.x -= 1
	elif x_dif <= -3:
		velocity.x += 1
	else:
		self.position.x = current_checkpoint[0]

	
	if y_dif >= 3:
		velocity.y -= 1
	elif y_dif <= -3:
		velocity.y += 1
	else:
		self.position.y = current_checkpoint[1]

	

	# if the character has arrived at the checkpoint, check if there is a delay
	if self.position.x == current_checkpoint[0] and self.position.y == current_checkpoint[1]:
		pause_timer += delta
		if pause_timer > current_checkpoint[2]:
			
			if current_destination == checkpoints.size() - 1:
				current_destination = 0
			else:
				current_destination += 1
			pause_timer = 0
			current_checkpoint = checkpoints[current_destination]
			if current_checkpoint[3] == 0:
				current_check_viz = false
			else:
				current_check_viz = true
			
			
			self.visible = current_check_viz
		else:
			
			self.visible = current_check_viz
	else:
		self.visible = true

	velocity = velocity.normalized() * speed


func _physics_process(delta):
	var direction = velocity.normalized()
	if moves:
		update_velocity(delta)
		velocity = move_and_slide(velocity)
	# Update player animation
	animation_manager(direction)
	
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
	
func talk(answer = ""):
	# load file and parse JSON
	var dialogue = load_file(dialogue_file)
	
	
	# Set dialoguePopup npc to neighbor
	dialogue_popup.npc = self
	
	# set animation to idle in direction of player
	var player_to_npc_x_delta = player.position.x - self.position.x
	var player_to_npc_y_delta = player.position.y - self.position.y
	
	# if player is further on the x axis, then the rotation should be on x axis
	if abs(player_to_npc_x_delta) > abs(player_to_npc_y_delta):
		if player_to_npc_x_delta > 0:
			$AnimatedSprite.play("idle_left")
		elif player_to_npc_x_delta < 0:
			$AnimatedSprite.play("idle_right")
	else:
		if player_to_npc_y_delta < 0:
			$AnimatedSprite.play("idle_up")
		elif player_to_npc_y_delta > 0:
			$AnimatedSprite.play("idle_down")
	# Get state of dialogue
	if answer != "":
		var state_next = state_data.next
		if answer == 'Z':
			dialogue_state = state_next[0].id
		elif answer == 'X' and len(state_next) > 1:
			dialogue_state = state_next[1].id
		elif answer == 'C' and len(state_next) > 2:
			dialogue_state = state_next[2].id
		elif answer == 'V' and len(state_next) > 3:
			dialogue_state = state_next[3].id
		else:
			dialogue_state = dialogue.start
		
	# Check if done
	if dialogue_state == "-1":
		dialogue_state = "0"
		dialogue_popup.close()
		# Keep track of the number of interactions between player and NPCs
		if npc_name in PlayerData.conversations_held:
			PlayerData.conversations_held[npc_name] += 1
		else:
			PlayerData.conversations_held[npc_name] = 1
		print(PlayerData.conversations_held)
		return
	
	
	
	# Set possible buttons
	# TODO don't hardcode this here
	var buttons = ['Z', 'X', 'C', 'V']
	
	var ans
	
	var answers = ""
	state_data = dialogue.lines[dialogue_state]
	dialogue_popup.npc_name = state_data.actor.replace("%player%", player.player_name)
	dialogue_popup.dialogue = state_data.text.replace("%player%", player.player_name)
	for i in range(len(state_data.next)):
		ans = state_data.next[i]
		answers += '[' + buttons[i] + "] " + ans.text + "  "
	dialogue_popup.answers = "[center]%s[/center]" % answers
	dialogue_popup.answers = dialogue_popup.answers.replace("%player%", player.player_name)
	dialogue_popup.open()

# load file and parse JSON
func load_file(file_path: String):
	var file = File.new()
	assert (file.file_exists(file_path))
	file.open(file_path, file.READ)
	return parse_json(file.get_as_text())
