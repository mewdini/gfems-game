extends Popup

var npc_name setget name_set
var dialogue setget dialogue_set
var answers setget answers_set
var npc
var tool_tip

func name_set(new_value):
	npc_name = new_value
	$ColorRect2/MarginContainer/CharacterName.bbcode_text = new_value

func dialogue_set(new_value):
	dialogue = new_value
	$ColorRect/MarginContainer/Dialogue.bbcode_text = new_value

func answers_set(new_value):
	answers = new_value
	$ColorRect3/MarginContainer/Answers.bbcode_text = new_value

func open():
	get_tree().paused = true
	popup()
	if dialogue.length() > 0:
		$ColorRect/MarginContainer/Dialogue/DialogueAnimation.playback_speed = 60.0 / dialogue.length()
		$ColorRect/MarginContainer/Dialogue/DialogueAnimation.play("ShowDialogue")

	if answers.length() > 0:
		$ColorRect3/MarginContainer/Answers/AnimationPlayer.playback_speed = 60.0 / answers.length()
		$ColorRect3/MarginContainer/Answers/AnimationPlayer.play("ShowDialogue")
	tool_tip.percent_visible = 0
	
func close():
	get_tree().paused = false
	tool_tip.percent_visible = 1
	hide()
	
func _ready():
	tool_tip = get_tree().root.get_node("Root/UserInterface/UserInterface/ToolTipLabel")
	set_process_input(false)


func _on_AnimationPlayer_animation_finished(anim_name):
	set_process_input(true)
	
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_Z:
			set_process_input(false)
			npc.talk('Z')
		elif event.scancode == KEY_X:
			set_process_input(false)
			npc.talk('X')
		elif event.scancode == KEY_C:
			set_process_input(false)
			npc.talk('C')
		elif event.scancode == KEY_V:
			set_process_input(false)
			npc.talk('V')
		elif event.scancode == KEY_B:
			set_process_input(false)
			npc.talk('B')
