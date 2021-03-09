# DialogBox.gd
extends RichTextLabel

# Variables
var dialog = [
	"Hey! My name is Benjamin.",
	"Welcome to my Godot dialog tutorial."]
var page = 0

# Functions
func _ready():
	set_process_input(true)
	set_bbcode(dialog[page])
	set_visible_characters(0)

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON && event.is_pressed():
		if get_visible_characters() > get_total_character_count():
			if page < dialog.size()-1:
				page += 1
				set_bbcode(dialog[page])
				set_visible_characters(0)
		else:
			set_visible_characters(get_total_character_count())

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters()+1)
