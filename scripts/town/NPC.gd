extends KinematicBody2D
class_name NPC

export (int) var speed = 300

# pathfinding variables
var velocity = Vector2()


# checkpoints are set up as tuples with x, y, delay at point in seconds, and visibility
var checkpoints = [[3075, 2304, 0, trawue]] # this will generally not run
var current_destination = 0
var current_checkpoint
var pause_timer = 0
var x_dif
var y_dif

# references
var dialogue_popup
var player

var dialogue_state = "0"
var state_data
var dialogue_file = "res://dialogue/neighbor.json"

func _init(_dialogue_file, _checkpoints).():
	dialogue_file = _dialogue_file
	checkpoints = _checkpoints

func _ready():
	dialogue_popup = get_tree().root.get_node("Root/CanvasLayer/DialoguePopup")
	player = get_tree().root.get_node("Root/Player")

# state machine
# check position, then update seen/velocity
func update_velocity(delta):
	velocity = Vector2()

	# get info about current checkpoint and check how far npc is from there
	current_checkpoint = checkpoints[current_destination]
	x_dif = self.position.x - current_checkpoint[0]
	y_dif = self.position.y - current_checkpoint[1]

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
			if checkpoints[current_destination][3]:
				self.visible = checkpoints[current_destination][3]
		else:
			self.visible = current_checkpoint[3]

	velocity = velocity.normalized() * speed


func _physics_process(delta):

	update_velocity(delta)
	velocity = move_and_slide(velocity)
	
	
func talk(answer = ""):
	# load file and parse JSON
	var dialogue = load_file(dialogue_file)
	
	# Set dialoguePopup npc to neighbor
	dialogue_popup.npc = self
	
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
