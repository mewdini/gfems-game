#https://www.youtube.com/watch?v=mjWwWIEyib8

extends Node

signal currency_updated
signal inventory_updated

var currency: = 4000 setget set_currency
var inventory: = []

func reset():
	currency = 0


func set_currency(value: int):
	currency = value
	emit_signal("currency_updated")
