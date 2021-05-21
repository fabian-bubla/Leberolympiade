extends Node2D

export var scene_combo_threshhold = 7
func _ready():
	for member in get_tree().get_nodes_in_group("WineGlasses"):
		member.combo_attack_threshhold = scene_combo_threshhold
		
	pass # Replace with function body.
