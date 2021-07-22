extends Sprite

onready var shader = preload("res://shaders/aura.shader")

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			self.material = ShaderMaterial.new()
			self.material.shader = shader
			PlayerData.set_sprite(PlayerData.Sprite_Name.DAN)
