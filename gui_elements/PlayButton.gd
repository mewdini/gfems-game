tool
extends Button

export(String, FILE) var next_scene_path: = ""

func _on_button_up():
	get_tree().set_pause(false)
	get_tree().change_scene(next_scene_path)

func _get_configuration_warning():
	return "next_scene_path must be set" if next_scene_path == "" else ""
