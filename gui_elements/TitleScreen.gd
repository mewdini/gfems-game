extends Control

onready var load_button = find_node("LoadButton")

func _ready():
	var save_info = load_file("res://save/state.json")
	if save_info:
		load_button.visible = true
	
# load file and parse JSON
func load_file(file_path: String):
	var file = File.new()
	if file.file_exists(file_path):
		file.open(file_path, file.READ)
		return parse_json(file.get_as_text())
