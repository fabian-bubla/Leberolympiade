extends Node2D

var counter = 0

var xpositions_2_player = [108, 212]
var xpositions_4_player = [64, 128, 192, 256]
var y_position = 152


func _ready():
	
	spawn_number_of_players()
	pass
#	if Stats.player_number == 2:
#		duel_selected()
#	elif Stats.player_number == 4:
#		party_selected()


#func duel_selected():
#	print('Duel Selected')
#
#	$Duel.visible = true
#	$Party.visible = false
##	$Party.paused = true
##	PauseMode = stop
#
#
#func party_selected():
#	print('Party Selected')
#
#	$Party.visible = true
#	$Duel.visible = false
##	$Party.paused = true


func all_players_selected():
	counter = 0
	if $Characters.get_child_count() == Stats.player_number:
		for character in $Characters.get_children():
			if character.char_unlocked == true:
				return
			else:
				counter += 1
#				print(counter)
				if counter == Stats.player_number:
					AudioManager.play_or_stop_track(AudioManager.menuTrack)
					print('stopped menuTrack')
					if Stats.player_number == 2:
						get_tree().change_scene("res://assets/Duel_Scene.tscn")
					elif Stats.player_number == 4:
						get_tree().change_scene("res://assets/Party_Scene.tscn")
#				if $Duel.visible == true and counter == Stats.player_number:
##					AudioManager.stop_music()
#					AudioManager.play_or_stop_track(AudioManager.menuTrack)
#					get_tree().change_scene("res://assets/Duel_Scene.tscn")
#				elif $Party.visible == true and counter == Stats.player_number:
##					AudioManager.stop_music()
#					AudioManager.play_or_stop_track(AudioManager.menuTrack)
#					get_tree().change_scene("res://assets/Party_Scene.tscn")
				
#	elif Stats.player_number == 4:
#		for character in $Characters.get_children():
#			if character.char_unlocked == true:
#				return
#			else:
#				counter += 1
##				print(counter)
#				if counter == Stats.player_number:
#					AudioManager.play_or_stop_track(AudioManager.menuTrack)
#					print('stopped menuTrack')
#					get_tree().change_scene("res://assets/Party_Scene.tscn")
#				if $Duel.visible == true and counter == Stats.player_number:
##					AudioManager.stop_music()
#					AudioManager.play_or_stop_track(AudioManager.menuTrack)
#					get_tree().change_scene("res://assets/Duel_Scene.tscn")
#				elif $Party.visible == true and counter == Stats.player_number:
##					AudioManager.stop_music()
#					AudioManager.play_or_stop_track(AudioManager.menuTrack)
#					get_tree().change_scene("res://assets/Party_Scene.tscn")
					
			
func spawn_number_of_players():
	
	for character in Stats.player_number:
		
		var hand_sprite = load("res://HandSprite.tscn").instance()
#		var new_hand = hand_sprite.new()
		if Stats.player_number == 2:
			hand_sprite.position = Vector2(xpositions_2_player[character], y_position)
		elif Stats.player_number == 4:
			hand_sprite.position = Vector2(xpositions_4_player[character], y_position)
		hand_sprite.Control_Scheme = character
		$Characters.add_child(hand_sprite)
		
