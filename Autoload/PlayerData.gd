#https://www.youtube.com/watch?v=mjWwWIEyib8

extends Node

signal currency_updated
signal inventory_updated
signal door_entered

enum Sprite_Name {DAN, AMELIA}

var currency: = 4000 setget set_currency
var inventory: = []
var last_door_entered: = "" setget set_door
var current_scene: = "" setget set_current_scene
var last_location: = {"res://levels/town.tscn":Vector2(717, 1325)}
var start_animation = "idle_down" setget set_start_anim

# variable to keep track of how many conversations character has had with each 
# NPC
var conversations_held = {}

var char_name: = "missingno"

var sprite_name = Sprite_Name.DAN

func reset():
	currency = 0

func set_current_scene(value: String) -> void:
	current_scene = value

func set_currency(value: int) -> void:
	currency = value
	emit_signal("currency_updated")

func set_door(value: String) -> void:
	last_door_entered = value
	emit_signal("door_entered")

func set_name(value: String) -> void:
	char_name = value

func set_sprite(value: int) -> void:
	sprite_name = value
	
func set_start_anim(value: String) -> void:
	start_animation = value

func get_char_name() -> String:
	return char_name

func get_sprite() -> int:
	return sprite_name

# This will only get called from the title screen
func load(save_data) -> void:
	char_name = save_data[0]
	sprite_name = save_data[1]
	currency = save_data[2]
	last_door_entered = save_data[3]
	inventory = save_data[4]
	conversations_held = save_data[5]
	current_scene = save_data[6]

	print(save_data)

func save() -> void:
	var save_data = [char_name, sprite_name, currency, last_door_entered, inventory, conversations_held, current_scene]
	var file = File.new()
	file.open('save/state.json', file.WRITE)
	file.store_line(to_json(save_data))
	file.close()
