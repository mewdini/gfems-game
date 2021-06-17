#https://www.youtube.com/watch?v=mjWwWIEyib8

extends Node

signal currency_updated
signal inventory_updated

enum Sprite_Name {DAN, AMELIA}

var currency: = 4000 setget set_currency
var inventory: = []

var char_name: = "missingno"

var sprite_name = Sprite_Name.DAN

func reset():
	currency = 0

func set_currency(value: int) -> void:
	currency = value
	emit_signal("currency_updated")

func set_name(value: String) -> void:
	char_name = value

func set_sprite(value: int) -> void:
	sprite_name = value

func get_char_name() -> String:
	return char_name

func get_sprite() -> int:
	return sprite_name
