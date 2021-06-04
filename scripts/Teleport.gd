tool
extends Area2D

onready var anim_player: AnimationPlayer = $AnimationPlayer

export var next_scene: PackedScene

export (int) var size_x setget set_x
export (int) var size_y setget set_y

func set_x(new_x):
	if new_x:
		size_x = new_x
		$CollisionShape2D.shape.extents.x = new_x
		update_configuration_warning()
	
func set_y(new_y):
	if new_y:
		size_y = new_y
		$CollisionShape2D.shape.extents.y = new_y
		update_configuration_warning()
		
func _get_configuration_warning():
	var warning = ""
	if size_x < 0:
		warning += "Please set `Size X` to a value greater than 0."
	if size_y < 0:
		# Add a blank line between each warning to distinguish them individually.
		if warning != "":
			warning += "\n"
		warning += "Please set `Size Y` to a value greater than 0."
	if not next_scene:
		if warning != "":
			warning += "\n"
		warning += "The next scene property can't be empty"

	# Returning an empty string means "no warning".
	return warning

func _on_body_entered(body: PhysicsBody2D) -> void:
		teleport()

func teleport() -> void:
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(next_scene)
