extends Sprite

var frames = hframes * vframes

var names = [
	'Painted Nails',
	'The Holder',
	'Fingies',
	'Aristocrat',
	'Minkie Moose',
	'realistic_hand.jpeg',
	'Bottom Hand',
	'Pommesgabel',
	'Rowbit',
	'Hook',
	'Tongue',
	'The Pooper',
	'Kittie Cat',
	'Hoofington',
	'Kremit',
	'Crabbers',
	'Spoiderman',
	'Goofy Gopher',
	'McKlukerz',
	'Baystayck',
	'Karate Chop Sticks',
	'Zwei-Schwerter-Theorie',
	'FlyS.W.A.Tter',
	'Nacho with Cheese',
	'Rubber Chicken',
	'USB Shtick',
	'Glowpear',
	'Black Hole',
	'Leprecorn',
	'4-Leaf Clover',
	'Poto\'Gold',
	'Snäk',
	'Dirtwater',
	'Der Jonas',
	'Bird',
	'9.8m/s² Sword',
	'Shwombolom',
	'Lantern',
	'Finlay Found',
	'The Postperson',
	'Spooky Skeleton',
	'Die'
]

func _ready():
#	pass
	while true:
		randomize()
		var rnd_idx = randi() % frames
		if !Stats.Sprite_idx_already_in_use.has(rnd_idx):
			self.frame = rnd_idx
			Stats.Sprite_idx_already_in_use.append(rnd_idx)
			break
#		self.frame = Stats.Sprite_idx_list[random_sprite_idx]
#		Stats.Sprite_idx_list.remove(random_sprite_idx)
#		pass # Replace with function body.

 
