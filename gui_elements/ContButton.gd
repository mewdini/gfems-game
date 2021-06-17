extends Button

onready var sprite_name: int

func _on_button_up():
	PlayerData.set_name(get_node("../NameLineEdit").get_text())
	get_tree().set_pause(false)
	get_tree().change_scene("res://levels/Town.tscn")
