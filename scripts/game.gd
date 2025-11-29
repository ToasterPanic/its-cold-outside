extends Node2D

var power = 0
var temperature = -10
var boughts = {
	
}

var time_to_next_passive_power = 1

var buyable_ui_item_scene = preload("res://scenes/buyable_ui_item.tscn")

func _ready() -> void:
	$CanvasLayer/Control/Panel/VBoxContainer/BuyableUIItem.free()
	
	for n in global.buyables.keys():
		boughts[n] = 0
		
		var buyable_ui_item = buyable_ui_item_scene.instantiate()
		buyable_ui_item.set_meta("type", n)
		buyable_ui_item.game = self
		
		$CanvasLayer/Control/Panel/VBoxContainer.add_child(buyable_ui_item)

func _process(delta: float) -> void:
	time_to_next_passive_power -= delta
	if time_to_next_passive_power <= 0:
		time_to_next_passive_power = 1 
		
		temperature = -10
		
		for n in boughts.keys():
			power += global.buyables[n].passive_power * boughts[n]
			
			temperature += global.buyables[n].heat * boughts[n]
		
	$Jeffery.rotation_degrees /= 1 + (delta * 6)
	$Jeffery.scale.x -= ($Jeffery.scale.x - 1) * (delta * 3)
	$Jeffery.scale.y = $Jeffery.scale.x
	
	$CanvasLayer/Control/PowerMeter.text = str(floori(power)) + " POWER"
	
	$CanvasLayer/Control/TemperatureMeter.text = str(temperature) + "°"

	$Camera2D.position.x = get_viewport().size.x / -4

	
func _on_jeffery_pressed() -> void:
	power += 1
	$Jeffery.rotation_degrees = randf_range(-5, 5)
	$Jeffery.scale.x = 1.1
	$Jeffery.scale.y = 1.1
	
	$Jeffery/ClickHint.visible = false
