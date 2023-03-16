extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_random_shout():
	randomize()
	var nr_chldr = $Shouts.get_child_count()
	var rnd_child = randi() % nr_chldr
	$Shouts.get_child(rnd_child).play()
	
func play_win_sfx():
	$WinSFX.play(0.0)

func mute_win_sfx():
	$WinSFX.stop()
