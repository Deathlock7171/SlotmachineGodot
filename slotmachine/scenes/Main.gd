extends Node2D

@onready var background = $Background
@onready var slot = $SubViewportContainer/SubViewport/SlotMachine
@onready var roll_button = $RollButton

func _ready():
	slot.stopped.connect(_on_slot_machine_stopped)

func _on_Roll_button_down():
	if roll_button.text == "Roll":
		slot.start()
		roll_button.text = "Stop"
	else:
		slot.stop()

func _on_slot_machine_stopped():
	roll_button.text = "Roll"
