var dialogue_file = "res://dialogue/neighbor.json"
var checkpoints = [[3075, 2304, 0, true], [1839, 2304, 0, true], [1839, 2117, 3, false], [1839,2304, 0, true], [3075,2304, 0, true], [3075,2174, 3, false]]

# pathfinding variables
var velocity = Vector2()
var going_home = true
var inside_timer = 0

# references
var dialogue_popup
var player

var response_num = "0"
var curr_data

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
		var next_data = curr_data.next
		if answer == 'Z':
			response_num = next_data[0].id
		elif answer == 'X' and len(next_data) > 1:
			response_num = next_data[1].id
		elif answer == 'C' and len(next_data) > 2:
			response_num = next_data[2].id
		elif answer == 'V' and len(next_data) > 3:
			response_num = next_data[3].id
		else:
			response_num = dialogue.start

	# Check if done
	if response_num == "-1":
		response_num = "0"
		dialogue_popup.close()
		return

	# Set possible buttons
	# TODO don't hardcode this here
	var buttons = ['Z', 'X', 'C', 'V']
	
	var ans
	
	var answers = ""
	curr_data = dialogue.lines[response_num]
	dialogue_popup.npc_name = curr_data.actor.replace("%player%", player.player_name)
	dialogue_popup.dialogue = curr_data.text.replace("%player%", player.player_name)
	for i in range(len(curr_data.next)):
		ans = curr_data.next[i]
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
