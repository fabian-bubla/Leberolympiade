extends Node2D

export var scene_combo_threshhold = 10
export var scene_score_to_achieve = 30
func _ready():
	for member in get_tree().get_nodes_in_group("WineGlasses"):
		member.combo_attack_threshhold = scene_combo_threshhold
	Stats.max_score = scene_score_to_achieve
	GameEvents.connect("game_won",self, "_on_game_won")
	GameEvents.connect("enable_continue",self, "_enable_continue")
	
	pass # Replace with function body.

func _on_game_won():
	$WinScreenTexts.visible = true
	$Music.stop()
	AudioManager.play_win_sfx()
	
#	
	pass
	
func _enable_continue():
	for member in get_tree().get_nodes_in_group("WineGlasses"):
		member.round_over = true
