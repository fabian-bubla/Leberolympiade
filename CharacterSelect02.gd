extends Node2D

var counter = 0

var xpositions_2_player = [108, 212]
var xpositions_4_player = [64, 128, 192, 256]
var y_position = 152


func _ready():
# warning-ignore:return_value_discarded
	GameEvents.connect("character_selected",self, "_on_character_selected")
	
	spawn_number_of_players()


func _on_character_selected():
	
	counter = 0
	
		
	for character in $Characters.get_children():
		
		if character.char_unlocked:
			return
		else:
			counter += 1
			
			if counter == Stats.player_number:
				AudioManager.play_or_stop_track(AudioManager.menuTrack)
				
				if Stats.player_number == 2:
# warning-ignore:return_value_discarded
					get_tree().change_scene("res://assets/Duel_Scene.tscn")
				elif Stats.player_number == 4:
# warning-ignore:return_value_discarded
					get_tree().change_scene("res://assets/Party_Scene.tscn")
					
			
func spawn_number_of_players():
	
	for character in Stats.player_number:
		
		var hand_sprite = load("res://HandSprite.tscn").instance()
		
		if Stats.player_number == 2:
			hand_sprite.position = Vector2(xpositions_2_player[character], y_position)
		elif Stats.player_number == 4:
			hand_sprite.position = Vector2(xpositions_4_player[character], y_position)
			
		hand_sprite.Control_Scheme = character
		$Characters.add_child(hand_sprite)
		
