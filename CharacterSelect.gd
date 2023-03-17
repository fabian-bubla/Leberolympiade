extends Node2D

var counter = 0

func _ready():
	if Stats.player_number == 2:
		duel_selected()
	else:
		party_selected()


#	var test_array = [0,0,0,0]
#
#	test_array[0] = 'hello'
#	test_array[2] = 'world'
#
#	print(test_array)


func duel_selected():
	print('Duel Selected')
	
	$Duel.visible = true
	$Party.visible = false
#	$Party.paused = true
#	PauseMode = stop
	
func party_selected():
	print('Party Selected')
	
	$Party.visible = true
	$Duel.visible = false
#	$Party.paused = true

func all_players_selected():
	counter = 0
	if Stats.player_number == 2:
		for character in $Duel.get_children():
			if character.char_unlocked == true:
				return
			else:
				counter += 1
				print(counter)
				if $Duel.visible == true and counter == Stats.player_number:
					AudioManager.stop_music()
					get_tree().change_scene("res://assets/Duel_Scene.tscn")
				elif $Party.visible == true and counter == Stats.player_number:
					AudioManager.stop_music()
					get_tree().change_scene("res://assets/Party_Scene.tscn")
				
	elif Stats.player_number == 4:
		for character in $Party.get_children():
			if character.char_unlocked == true:
				return
			else:
				counter += 1
				print(counter)
				if $Duel.visible == true and counter == Stats.player_number:
					AudioManager.stop_music()
					get_tree().change_scene("res://assets/Duel_Scene.tscn")
				elif $Party.visible == true and counter == Stats.player_number:
					AudioManager.stop_music()
					get_tree().change_scene("res://assets/Party_Scene.tscn")
			
