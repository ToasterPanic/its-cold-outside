extends Node

var upgrades = {
	"politics": {
		"description": "Involve yourself in politics to gain POWER. Increases your energy cap to 25K, and gives access to new items in the Store.",
		"name": "Politics",
		"costs": {
			"energy": 10000
		}
	},
	"deregulation": {
		"description": "Convince the government to give you the freedom to destroy the planet more. Increases your energy cap to 100K.",
		"name": "Deregulation",
		"costs": {
			"energy": 10000,
			"upgrade": "politics"
		},
		"requires_upgrade": "politics"
	},
	"president": {
		"description": "Become the president of [MYSTERY COUNTRY]! x2 multiplier to all POWER sources.",
		"name": "Presidency",
		"costs": {
			"energy": 20000,
			"power": 10000
		},
		"requires_upgrade": "politics"
	},
	"research": {
		"description": "Reveals new",
		"name": "Research",
		"costs": {
			"energy": 10000
		}
	}
}

var buyables = {
	"space_heater": {
		"passive_energy": 3,
		"heat": 0.01,
		"max_amount": 10,
		"cost": 50,
		
		"name": "Space Heater",
	},
	"campfire": {
		"passive_energy": 5,
		"heat": 0.02,
		"max_amount": 10,
		"cost": 120,
		
		"name": "Campfire",
	},
	"bribe": {
		"passive_energy": 0,
		"passive_power": 2,
		"heat": 0.1,
		"max_amount": 10,
		"cost_power": 100,
		"requires_upgrade": "politics",
		
		"name": "Bribe",
	},
	"ai_datacenter": {
		"passive_energy": 0,
		"passive_power": 25,
		"heat": 0.1,
		"max_amount": 10,
		"cost": 100000,
		"requires_upgrade": "advanced_technology",
		
		"name": "AI Datacenter",
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
