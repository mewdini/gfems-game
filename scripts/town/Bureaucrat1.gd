extends KinematicBody2D

export (int) var speed = 300
export (float) var time_inside = 3

# pathfinding variables
var velocity = Vector2()
var going_home = true
var inside_timer = 0

# references
var dialogue_popup
var player

var dialogue_state = "0"
var state_data

func _ready():
	dialogue_popup = get_tree().root.get_node("Root/CanvasLayer/DialoguePopup")
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
	# load file and parse JSON
	var dialogue = load_file("res://dialogue/neighbor.json")
	
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
