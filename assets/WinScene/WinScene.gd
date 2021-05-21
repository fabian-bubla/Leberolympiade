extends Node2D

var win_list = Stats.win_list
func _ready():
	
	pass # Replace with function body.

func set_correct_sprites():
	for i in $Players.get_children():
		i.visible = true
		i.get_node('Sprite').frame = 
