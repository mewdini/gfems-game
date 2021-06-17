#https://www.youtube.com/watch?v=mjWwWIEyib8

extends Node

signal currency_updated
signal inventory_updated
signal door_entered

var currency: = 4000 setget set_currency
var inventory: = []
var last_door_entered: = "" setget set_door
var last_location: = {"res://levels/town.tscn":Vector2(668,1196)}

func reset():
	currency = 0

func set_currency(value: int):
	currency = value
	emit_signal("currency_updated")

func set_door(value: String):
	last_door_entered = value
	emit_signal("door_entered")
