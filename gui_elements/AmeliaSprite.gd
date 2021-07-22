extends Sprite

onready var shader = preload("res://shaders/aura.shader")

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			for i in self.get_parent().get_children():
				if i != self:
					i.material = null
			self.material = ShaderMaterial.new()
			self.material.shader = shader
			PlayerData.set_sprite(PlayerData.Sprite_Name.AMELIA)
