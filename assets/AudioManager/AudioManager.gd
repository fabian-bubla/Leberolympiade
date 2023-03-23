extends Node

onready var winSFX = $WinSFX
onready var menuTrack = $MenuTrack


func play_or_stop_track(track):
	if track.playing == true:
		track.stop()
	else:
		track.play(0.0)
		

#func play_random_shout():
#	randomize()
#	var nr_chldr = $Shouts.get_child_count()
#	var rnd_child = randi() % nr_chldr
#	$Shouts.get_child(rnd_child).play()
