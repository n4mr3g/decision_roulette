extends Node

@onready var roulette = $"%Roulette"
@onready var ui = $"%UICanvasGroup"
@onready var winner_label = ui.get_node("WinnerLabel")  # Cache the WinnerLabel


func _ready():
	# Connect the signals from the UI scene to the methods in the main script
	ui.connect("add_segments_pressed", Callable(self, "_on_add_segments_pressed"))
	ui.connect("spin_wheel_pressed", Callable(self, "_on_spin_wheel_pressed"))

func _process(delta):
	var current_winner = roulette.get_current_winner_segment()
	if current_winner != "":
		update_winner_label(current_winner)
		
	

func update_winner_label(winner_text: String):
	if winner_label && winner_label.text != winner_text:
		winner_label.text = "The winner is... " + winner_text
		
func _on_add_segments_pressed(labels):
	roulette.populate_labels(labels)
	roulette.create_segments(labels.size())
	roulette.visible = true

func _on_spin_wheel_pressed():
	roulette.spin_wheel()
