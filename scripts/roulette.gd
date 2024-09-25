extends SubViewportContainer

@export var wheel_radius: float = 200.0
@export var segment_count: int = 0  # Number of segments
@export var winner_label = ""
@onready var canvas = $"SubViewport/Roulette CanvasGroup"


var labels = []

var segments = []
var is_spinning = false

signal winner_detected(winner_text: String)

func populate_labels(labels_from_user):
	labels.clear() 
	
	for label in labels_from_user:
		labels.append(label)

func get_current_winner_segment() -> String:
	var current_angle = wrapf(-canvas.get_rotation_degrees(), 0, 360)
	if segment_count == 0:
		return ""


	var angle_step = 360.0 / segment_count
	var segment_index = int(floor(current_angle / angle_step))

	# Ensure the index is valid
	if segment_index >= 0 and segment_index < labels.size():
		return labels[segment_index]
	return ""



func get_color_for_segment(index: int, total: int) -> Color:
	var hue = float(index) / total
	return Color.from_hsv(hue, 1.0, 1.0)

func create_segments(amount_to_create: int):
	segment_count = amount_to_create
	# Clear previous segments
	for segment in segments:
		segment.queue_free()
	segments.clear()
	
		# Iterate through all the children of the canvas
	for child in canvas.get_children():
		# Check if the child is a Polygon2D or Label before removing it
		if child is Polygon2D or child is Label:
			child.queue_free()

	# Calculate the angle step for each segment
	var angle_step = 360.0 / segment_count

	for i in range(segment_count):
		var angle = i * angle_step
		var polygon = Polygon2D.new()
		var points = []

		# Calculate outer radius using the correct formula
		var outer_radius = wheel_radius / cos(deg_to_rad(angle_step / 2))

		# Define points for the segment
		points.append(Vector2(0, 0))  # Center
		points.append(Vector2(outer_radius, 0).rotated(deg_to_rad(angle)))
		points.append(Vector2(outer_radius, 0).rotated(deg_to_rad(angle + angle_step)))

		polygon.polygon = points
		polygon.color = get_color_for_segment(i, segment_count)
		canvas.add_child(polygon)
		segments.append(polygon)

		# Create label for the segment, ensuring labels are correctly indexed
		if i < labels.size():
			var label = create_label(labels[i], angle + angle_step / 2)  # Position in the center of the segment
			canvas.add_child(label)

func create_label(text: String, angle: float) -> Label:
	var label = Label.new()
	label.text = text
	label.set_custom_minimum_size(Vector2(50, 20))

	label.z_index = 1
	label.add_theme_constant_override("outline_size", 5)
	
	# Rotate to face outward
	label.rotation = deg_to_rad(angle)

	# Calculate the position based on the angle and an offset
	var distance_from_center = wheel_radius - 100  # Distance from the center to position the label
	label.position = Vector2(distance_from_center - 40, -10).rotated(deg_to_rad(angle))

	return label

func _process(delta):
	if is_spinning:
		var current_rotation = wrapf(canvas.get_rotation_degrees(), 0, 360)

		var segment_angle_size = 360.0 / segment_count
		
		for i in range(segment_count):
			var start_angle = i * segment_angle_size
			var end_angle = start_angle + segment_angle_size
			
			if current_rotation >= start_angle and current_rotation < end_angle:
				if i < labels.size():
					var current_segment_label = labels[i]
					winner_label = current_segment_label  # Update the winner label in real-time
				break

func spin_wheel():
	var spin_time = 3.0
	var random_angle = randf() * 360.0
	var current_rotation = canvas.get_rotation_degrees()
	var tween = create_tween()

	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(canvas, "rotation_degrees", current_rotation + random_angle + 360 * 5, spin_time)

	is_spinning = true
	tween.connect("finished", Callable(self, "_on_spin_finished"))

func _on_spin_finished():
	is_spinning = false
