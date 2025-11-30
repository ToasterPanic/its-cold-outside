extends PanelContainer


func _on_button_pressed() -> void:
	$Click.play()
	visible = false
	
	await get_tree().create_timer(0.666).timeout
	
	queue_free()
