#https://www.youtube.com/watch?v=mjWwWIEyib8

extends Node

signal currency_updated
signal inventory_updated
signal door_entered

enum Sprite_Name {DAN, AMELIA}

var currency: = 4000 setget set_currency
var inventory: = []
var last_door_entered: = "" setget set_door
var last_location: = {"res://levels/town.tscn":Vector2(717, 1325)}
var start_animation = "idle_down" setget set_start_anim

var char_name: = "missingno"

var sprite_name = Sprite_Name.DAN

func reset():
	currency = 0

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

