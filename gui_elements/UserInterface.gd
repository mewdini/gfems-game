extends Control

onready var scene_tree: = get_tree()
onready var pause_overlay: ColorRect = get_node("PauseMenuOverlay")
onready var currency: Label = get_node("CurrencyLabel")
onready var tooltip: Label = get_node("ToolTipLabel")

var paused:= false setget set_paused

func _ready():
	PlayerData.connect("currency_updated", self, "update_interface")
	update_interface()

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("pause"):
		self.paused = not paused
		scene_tree.set_input_as_handled()
		
func update_interface():
	 currency.text = "Currency: %s₫" % PlayerData.currency

func set_paused(value: bool):
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
