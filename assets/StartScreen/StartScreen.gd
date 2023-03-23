extends Node2D

var duell_scene = 'res://assets/Duel_Scene.tscn'
var party_scene = 'res://assets/Party_Scene.tscn'
var character_select = 'res://CharacterSelect.tscn'

func _ready():
	AudioManager.play_or_stop_track(AudioManager.menuTrack)
	
#	$Tween.interpolate_property($AudioStreamPlayer, 'volume_db',-80,-15, 5,Tween.TRANS_LINEAR,Tween.EASE_IN)
#	$Tween.interpolate_property($AudioStreamPlayer, 'pitch_scale', 0.5, 0.78, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	$Tween.start()
	
func _on_Duell_pressed():
	Stats.player_number = 2
# warning-ignore:return_value_discarded
	get_tree().change_scene(character_select)
	
	
func _on_Party_pressed():
	Stats.player_number = 4
# warning-ignore:return_value_discarded
	get_tree().change_scene(character_select)
