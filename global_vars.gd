extends Node

const constants = {
	"mainCharacter" = {
		"MAX_SPEED_X" = 400.0,
		"INC_SPEED_X" = 60.0,	
		"SLOW_DOWN" = 40.0,
		"JUMP_VELOCITY" = -730.0,
		"WALL_JUMP_EXTRA_VELOCITY" = -365.0
	},	
	"ennemies" = {
		"bat" =  {
			"SPEED" = -350,
			"JUMP_VELOCITY" = -400,
		},
	},
	"backgroundVolume" = {
		"baseVolume" = -20,
		"minSlider" = 0,
		"maxSlider" = 2,
	},
	"sfxVolume" = {
		"baseVolume" = -25,
		"minSlider" = 0,
		"maxSlider" = 2,
	},
	"masterVolume" = {
		"minSlider" = 0,
		"maxSlider" = 2,
	}
}
