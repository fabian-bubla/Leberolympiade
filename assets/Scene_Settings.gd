extends Node2D

export var scene_combo_threshhold = 10
export var scene_score_to_achieve = 30

func _ready():
	for member in get_tree().get_nodes_in_group("WineGlasses"):
		member.combo_attack_threshhold = scene_combo_threshhold
	Stats.max_score = scene_score_to_achieve
# warning-ignore:return_value_discarded
	GameEvents.connect("game_won",self, "_on_game_won")
# warning-ignore:return_value_discarded
	GameEvents.connect("enable_continue",self, "_enable_continue")

func _on_game_won():
	$WinScreenTexts.visible = true
	$Music.stop()
#	AudioManager.play_win_sfx()
	AudioManager.play_or_stop_track(AudioManager.winSFX)
	
func _enable_continue():
	for member in get_tree().get_nodes_in_group("WineGlasses"):
		member.round_over = true
