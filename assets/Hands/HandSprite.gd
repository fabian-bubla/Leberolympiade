extends Sprite


func _ready():
#	pass
	while true:
		randomize()
		var rnd_idx = randi() % 16
		if !Stats.Sprite_idx_already_in_use.has(rnd_idx):
			self.frame = rnd_idx
			Stats.Sprite_idx_already_in_use.append(rnd_idx)
			break
#		self.frame = Stats.Sprite_idx_list[random_sprite_idx]
#		Stats.Sprite_idx_list.remove(random_sprite_idx)
#		pass # Replace with function body.

