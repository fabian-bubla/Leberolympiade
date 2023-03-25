extends Sprite


onready var char_name = $Label

var char_unlocked = true

export (int) var Control_Scheme = 0

onready var int_button_dict = Controls[Control_Scheme]
var Controls = [
	{
	0: "ui_left",
	1: "ui_right",
	2: "ui_up",
	3: "ui_down",
	4: "ui_attack",
	5: "ui_block",
	},
	{
	0: "button_left",
	1: "button_right",
	2: "button_up",
	3: "button_down",
	4: "button_attack",
	5: "button_block",
	},
	{
	0: "1ui_left",
	1: "1ui_right",
	2: "1ui_up",
	3: "1ui_down",
	4: "1ui_attack",
	5: "1ui_block",
	},
	{
	0: "1button_left",
	1: "1button_right",
	2: "1button_up",
	3: "1button_down",
	4: "1button_attack",
	5: "1button_block",
	}
]

onready var names = [
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
	'Irish Dirtwater',
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
	change_name()
	if Control_Scheme % 2 != 0:
		char_name.rect_position.y += 20
	if Control_Scheme > (Stats.player_number/2 - 1):
		self.flip_h = true

func _process(_delta):
	
	if Input.is_action_just_pressed(int_button_dict.values()[0]) and char_unlocked:
		if self.frame - 1 < 0:
			frame += hframes * vframes - 1
		else:
			self.frame -= 1
			
		change_name()
		
	if Input.is_action_just_pressed(int_button_dict.values()[1]) and char_unlocked:
		if self.frame + 1 == hframes * vframes:
			frame -= hframes * vframes - 1
		else:
			self.frame += 1
			
		change_name()
		
	if Input.is_action_just_pressed(int_button_dict.values()[2]) and char_unlocked:
		Stats.selected_characters[Control_Scheme] = frame
		
		char_unlocked = false
		self.position.y -= 10
		self_modulate = Color("777777")
		
#		yield(get_tree().create_timer(2.0), "timeout")
		#Yield was bad because it created a timer in the tree that still existed when the scene
		#was changed and all of the HandSprites that created the timers were erased. This threw
		#an error and would have crashed the game.
		
		$Timer.start()
		
		
	if Input.is_action_just_pressed(int_button_dict.values()[3]):
		
		if char_unlocked == false:
			char_unlocked = true
			self.position.y += 10
			self_modulate = Color("ffffff")
	
	
func change_name():
	char_name.text = names[frame]


func _on_Timer_timeout():
	GameEvents.emit_signal("character_selected")