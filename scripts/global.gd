extends Node

var buyables = {
	"space_heater": {
		"passive_power": 3,
		"heat": 0.1,
		"max_amount": 10,
		"cost": 50,
		
		"name": "Space Heater",
	},
	"campfire": {
		"passive_power": 5,
		"heat": 0.2,
		"max_amount": 10,
		"cost": 120,
		
		"name": "Campfire",
	},
}

# Takes a number, makes it a string, abbreviates it by size
func numtext(number) -> String:
	if number >= 1e30:
		return str(floorf(number / 1e29) / 10) + "Oc"
	if number >= 1e27:
		return str(floorf(number / 1e26) / 10) + "Sp"
	if number >= 1e24:
		return str(floorf(number / 1e23) / 10) + "Sx"
	if number >= 1e21:
		return str(floorf(number / 1e20) / 10) + "Qi"
	if number >= 1e18:
		return str(floorf(number / 1e17) / 10) + "Qa"
	if number >= 1e15:
		return str(floorf(number / 1e14) / 10) + "Tr"
	if number >= 1e12:
		return str(floorf(number / 1e11) / 10) + "B"
	if number >= 1e9:
		return str(floorf(number / 1e8) / 10) + "M"
	if number >= 10000:
		return str(floorf(number / 100) / 10) + "K"
	
	return str(number)
