extends Node2D

export var scene_combo_threshhold = 10
export var scene_score_to_achieve = 30
func _ready():
	for member in get_tree().get_nodes_in_group("WineGlasses"):
		member.combo_attack_threshhold = scene_combo_threshhold
	Stats.max_score = scene_score_to_achieve
	pass # Replace with function body.
