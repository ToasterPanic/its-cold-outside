extends Node2D

func _process(delta: float) -> void:
	for n in get_children():
		if get_parent().temperature > 44:
			if n.get_name() == "Dead": n.modulate.a += delta
			else: n.modulate.a -= delta
		elif get_parent().temperature > 32:
			if n.get_name() == "Dying": n.modulate.a += delta
			else: n.modulate.a -= delta
		elif get_parent().temperature > 2:
			if n.get_name() == "NoSnow": n.modulate.a += delta
			else: n.modulate.a -= delta
		else:
			if n.get_name() == "Snow": n.modulate.a += delta
			else: n.modulate.a -= delta
			
		if n.modulate.a > 1: n.modulate.a = 1
		elif n.modulate.a < 0: n.modulate.a = 0
