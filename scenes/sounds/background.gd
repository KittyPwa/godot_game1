extends AudioStreamPlayer

@export var targetBackgroundPath : String

func _ready():
	self.stream = load(targetBackgroundPath)
	self.play(MusicProgress.music_progress)
	SignalBus.connect("resetMusic", reset)
	
func reset():
	MusicProgress.music_progress = self.get_playback_position()

