extends Node


var max_score = 2
var Sprite_idx_list = range(0,17)
var Sprite_idx_already_in_use = []
var win_list = []
func _ready():
	print(Sprite_idx_list)
	pass
	
func create_win_dict ():
	for member in get_tree().get_nodes_in_group("WineGlasses"):
		var temp_list = []
		temp_list.append(member.get_node('HandSprite').frame)
		temp_list.append(member.is_winner)
		temp_list.append(member.biggest_combo_counter)
		temp_list.append(member.attack_counter)
		temp_list.append(member.mistakes_counter)
		win_list.append(temp_list)
