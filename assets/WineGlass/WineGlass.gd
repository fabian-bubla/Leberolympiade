extends Node2D

var start_screen = "res://assets/StartScreen/StartScreen.tscn"
var round_over = false

export var controller_id = 0

var Input_left = []
var input_accomplished = []
var current_score = 0
var max_score = Stats.max_score #add that to some singleton
var inverted_flag = false
var combo_meter = 0 setget set_combo_meter

#STATS COUNTERS
var is_winner = false
var biggest_combo_counter = 0
var attack_counter = 0
var mistakes_counter = 0
#var is_winner = false



var wine_fill_value: float = 9.0
export (int) var Control_Scheme = 0
export var combo_attack_threshhold = 5
export var player_color_key = 0
export var drink_alpha = 'cc'
var input_blocked = false
var block_prompt = false
var player_color_dict = {
	0: "6e0022",
	1: "f6f392",
	2: 'e27b69',
	3: 'ffc30f',
}

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



func _ready():
	GameEvents.connect("block_all_players_input", self,"_on_block_all_players_input")
	GameEvents.connect("attack_launched", self, "_on_attack_launched")
	GameEvents.connect("game_won", self, "_on_game_won")
	randomize()
	generate_arrow_presses()
	modulate_all_assets(player_color_dict[player_color_key])
	hide_all_arrows()
	display_correct_arrow()
	display_name()
#	mirror_hand()
	pass


		

func _process(_delta):
	
	if round_over:
		if Input.is_action_just_pressed(int_button_dict[4]):
			get_tree().change_scene(start_screen)
	
	elif block_prompt:
		if Input.is_action_just_pressed(int_button_dict.values()[-1]):
			pass
			block_prompt = false
			$AnimationPlayer.play("StrawAway")
#			$BlockPrompt.visible = false
			display_correct_arrow()
			#PLAY ANIMATION
			#remove block prompt
			#block_prompt = false
		else:
			for i in int_button_dict.values().slice(0,-2):#IDEA IS THAT any other button than block! RECHCECK
				if Input.is_action_just_pressed(i):
					pass
					punish_player()
					#punish player
					#remove block_prompt
		
	#LEFT CHECK
	elif !input_blocked:
#		print(input_not_diagonal())
#		if input_not_diagonal():
		#IS the Input pressed for the left side?
		for i in int_button_dict.values().slice(0,-3): #for all buttons but last, so attack button
			
			#which of the buttons of the left side where pressed iterate
			if Input.is_action_just_pressed(i):
				print(i)
				var next_press = int_button_dict[Input_left[0]]
				#is the next necessary press among them then:
				
				if Input.is_action_just_pressed(next_press):
					input_accomplished.append(Input_left.pop_front())
					increment()
	#				GameEvents.emit_signal("point_scored", self)
				else:#if wrong button! or elif but button still in the button_dict
					you_pressed_wrong_button()
					pass
	
	if Input.is_action_just_pressed(int_button_dict.values()[4]):
		if combo_meter >= combo_attack_threshhold:
			GameEvents.emit_signal("attack_launched", self)
			set_combo_meter(true)
			attack_counter += 1
			pass
		pass
	#interpolate amount of wine in Glass each frame
	$Tween.interpolate_property($Wine, 'margin_bottom', $Wine.margin_bottom,wine_fill_value,0.1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	

	
	
	

func input_not_diagonal():
	var direction = Vector2(Input.get_action_strength(Controls[0][1]) - Input.get_action_strength(Controls[0][0]),
			Input.get_action_strength(Controls[0][3]) - Input.get_action_strength(Controls[0][2]))
	if direction.length() > 1:
		return false
	else:
		return true
		
func display_name():
	$Label.text = $HandSprite.names[$HandSprite.frame]
	if Control_Scheme % 2 != 0:
		$Label.rect_position.y += 20
		
func mirror_hand():
	if Control_Scheme > 1:
		$HandSprite.scale.x = -1

func increment():
	set_combo_meter()
	if !inverted_flag:
		current_score = current_score + 1
	else:
		current_score = current_score - 1
		
	wine_fill_value = 9 + 62 /max_score * abs(current_score) #9 is min value and 62 is full value
	print(current_score, '    ', wine_fill_value)
	if current_score == max_score:
		invert()
		hide_all_arrows()
		display_correct_arrow()
#		win()
	elif current_score == 0 and inverted_flag == true:
		win()
#	elif current_score > max_score:
#		pass
	else:
		hide_all_arrows()
		display_correct_arrow()

func win():
	GameEvents.emit_signal("block_all_players_input")
	GameEvents.emit_signal("game_won")
	
#	$WinDisplay.win_display(biggest_combo_counter,attack_counter,mistakes_counter)
	is_winner = true
	
	
	for member in get_tree().get_nodes_in_group("WinDisplays"):
		member.win_display()

	$WinTimer.start()
	yield($WinTimer,"timeout")
#	get_tree().change_scene('res://assets/StartScreen/StartScreen.tscn')
	pass

func _on_game_won():
	$Glass.visible = false
	$LimeSprite.visible = false
	$xSprite.visible = false
	$Straw.visible = false
	$Wine.visible = false
	$GlassTransparent01.visible = false
	$Arrows.visible = false
	
	$WinTimer.wait_time = 5
	$WinTimer.autostart = true
	get_tree().get_root().gui_disable_input = true
	
	
	
	
func generate_arrow_presses():
	while Input_left.size() < Stats.max_score * 5:
		var new_num = randi() % 4
		if Input_left.size() == 0:
			Input_left.append(new_num)
		elif new_num != Input_left[-1]:
			Input_left.append(new_num)

func hide_all_arrows():
	var arrow_list = $Arrows.get_children()
	for i in arrow_list:
		i.visible = false

func display_correct_arrow():
	var arrow_list = $Arrows.get_children()
	arrow_list[Input_left[0]].visible = true
	pass

func invert():
	inverted_flag = true
#	input_accomplished.invert()
#	Input_left = input_accomplished
	pass

func you_pressed_wrong_button():
	mistakes_counter +=1
#	AudioManager.play_random_shout()
	$FailSFX.play()
	
	$BlockTimer.start()
	input_blocked = true
	$xSprite.visible = true
	hide_all_arrows()
	
	yield($BlockTimer,"timeout")
	
	display_correct_arrow()
	set_combo_meter(true)
	input_blocked = false
	$xSprite.visible = false
	pass

func set_combo_meter(reset=false):
	if reset == true:
		combo_meter = 0
#		$ComboMeter.text = str(0)
	else:
		combo_meter += 1
#		$ComboMeter.text = str(combo_meter)
	
	set_lime_sprite()
	
	if combo_meter >= biggest_combo_counter:
		biggest_combo_counter = combo_meter

func set_lime_sprite():
	var show_frame = 0
	if combo_attack_threshhold == 5:
		if combo_meter == 2:
			show_frame = 1
		if combo_meter == 3:
			show_frame = 2
		if combo_meter == 4:
			show_frame = 3
		if combo_meter >= 5:
			show_frame = 4
			
	if combo_attack_threshhold == 10:
		if combo_meter >= 4:
			show_frame = 1
		if combo_meter >= 6:
			show_frame = 2
		if combo_meter >= 8:
			show_frame = 3
		if combo_meter >= 10:
			show_frame = 4
	
	$LimeSprite.frame = show_frame
	
#	$LimeSprite.
func modulate_all_assets(color_code):
	#xSprite
	$xSprite.set_modulate(Color(color_code))
	#Wine
	$Wine/Wine.set_modulate(Color(drink_alpha + color_code))
	#all Arrows
	for i in $Arrows.get_children():
		i.set_modulate(Color(color_code))
	#ComboMeter
#	$ComboMeter.set_modulate(Color(color_code))
	print(color_code)
	pass

func _on_block_all_players_input():
	self.input_blocked = true
	pass

func _on_attack_launched(who):
	if who == self:
		pass #do nothing
	else:
		queue_block_prompt()

func queue_block_prompt():
	block_prompt = true
	$AnimationPlayer.play("StrawIn")
#	$BlockPrompt.visible = true
	hide_all_arrows()
#	set_combo_meter(true) #FIXME Make two counters one total and one since last, witha  bar!

func punish_player():
	mistakes_counter +=1
	AudioManager.play_random_shout()
	var punishment_value = 1
	set_combo_meter(true)
	if !inverted_flag:
		current_score = current_score - punishment_value
	else:
		current_score = current_score + punishment_value
		
	wine_fill_value = 9 + 62 /max_score * abs(current_score) 
	pass




func _on_WinTimer_timeout():
	get_tree().get_root().gui_disable_input = false
	print('What the heckey?')
	GameEvents.emit_signal("enable_continue")
