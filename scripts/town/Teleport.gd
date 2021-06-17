tool
extends Area2D

onready var anim_player: AnimationPlayer = $AnimationPlayer

export (String, FILE) var next_scene = ""
export (String) var transition_name = ""

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
	if next_scene == "":
		if warning != "":
			warning += "\n"
		warning += "The next scene property can't be empty"
	if transition_name == "":
		if warning != "":
			warning += "\n"
		warning += "The transition must be named"

	# Returning an empty string means "no warning".
	return warning

func _on_body_entered(body: PhysicsBody2D) -> void:
	teleport(body.get_position())

func teleport(player_position: Vector2) -> void:
	anim_player.play("fade_in")
	PlayerData.last_door_entered = transition_name
	PlayerData.last_location[get_tree().current_scene.filename.to_lower()] = player_position
	yield(anim_player, "animation_finished")
	get_tree().change_scene(next_scene)
