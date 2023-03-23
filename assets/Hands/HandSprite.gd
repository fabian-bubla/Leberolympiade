extends Sprite


func _ready():
	
	frame = Stats.selected_characters[get_parent().Control_Scheme]
	
#	Old randomization code

#	while true:
#		randomize()
#		var rnd_idx = randi() % frames
#		if !Stats.Sprite_idx_already_in_use.has(rnd_idx):
#			self.frame = rnd_idx
#			Stats.Sprite_idx_already_in_use.append(rnd_idx)
#			break
#		self.frame = Stats.Sprite_idx_list[random_sprite_idx]
#		Stats.Sprite_idx_list.remove(random_sprite_idx)

 
