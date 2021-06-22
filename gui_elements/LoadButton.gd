tool
extends Button

func _on_button_up():
	get_tree().set_pause(false)
	var save_info = load_file("res://save/state.json")
	PlayerData.load(save_info)
	print('loading data')
	get_tree().change_scene(PlayerData.current_scene)

# load file and parse JSON
func load_file(file_path: String):
	var file = File.new()
	if file.file_exists(file_path):
		file.open(file_path, file.READ)
		return parse_json(file.get_as_text())
