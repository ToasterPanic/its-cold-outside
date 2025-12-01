extends Label

var velocity_x = randi_range(-256, 256)
var velocity_y = randi_range(-256, -512)

var time = 0

func _process(delta: float) -> void:
	position.x += velocity_x * delta
	position.y += velocity_y * delta
	
	velocity_y += 1400 * delta
	
	time += delta
	
	if time > 2:
		queue_free()
