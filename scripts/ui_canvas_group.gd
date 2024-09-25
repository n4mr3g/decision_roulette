extends CanvasGroup

@warning_ignore("unused_signal")
signal add_segments_pressed(labels)
@warning_ignore("unused_signal")
signal spin_wheel_pressed()

@onready var text_edit = $TextEdit
@onready var add_button = $AddSegmentsButton
@onready var spin_button = $SpinWheelButton


func _ready():
	# Connect button signals to the corresponding methods in this script
	add_button.connect("pressed", Callable(self, "_on_add_segments_button_pressed"))
	spin_button.connect("pressed", Callable(self, "_on_spin_button_pressed"))

func _on_add_segments_button_pressed():
	var input_text = text_edit.text
	var raw_labels = input_text.split(",")
	var labels = []

	for label in raw_labels:
		label = label.strip_edges()
		if label != "":
			labels.append(label)

	if labels.size() < 2:
		print("Error: You need at least 2 labels to create the segments.")
		return

	emit_signal("add_segments_pressed", labels)

func _on_spin_button_pressed():
	emit_signal("spin_wheel_pressed")
