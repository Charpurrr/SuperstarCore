class_name BattlePlayerStats
extends Node
# The stats for every possible battle player

static var stats : Dictionary = {
	"mario": 
	{
		"level": 1,
		"hp": 10,
		"bp": 10,
		"pow": 12,
		"def": 9,
		"spd": 13,
		"sta": 6,
	},

	"luigi": 
	{
		"level": 1,
		"hp": 12,
		"bp": 10,
		"pow": 11,
		"def": 9,
		"spd": 12,
		"sta": 5,
	},
} # The default stats used in MARIO & LUIGI: SUPERSTAR SAGA (3DS)

# Level: Stats multiplier
# Health Points (HP): Amount of points you can lose until KO'd
# Bros. Points (BP): Amount of points you can lose until Bros. attacks become unavailable
# Power (POW): Increases the damage you do
# Defense (DEF): Decreases the damage you take
# Speed (SPD): How fast it's your turn
# Stache (STA): Your chance at lucky attacks, and discounts in SHOPS
