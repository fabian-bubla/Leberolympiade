extends Node2D

export var controller_id = 0

var Input_left = []
var input_accomplished = []
var current_score = 0
var max_score = Stats.max_score #add that to some singleton
var inverted_flag = false
var combo_meter = 0 setget set_combo_meter

var wine_fill_value: float = 9.0
export (int) var Control_Scheme = 0

var input_blocked = false

onready var int_button_dict = Controls[Control_Scheme]
var Controls = [
	{
	0: "ui_left",
	1: "ui_right",
	2: "ui_up",
	3: "ui_down",
	},
	{
	0: "button_left",
	1: "button_right",
	2: "button_up",
	3: "button_down",
	},
	{
	0: "1ui_left",
	1: "1ui_right",
	2: "1ui_up",
	3: "1ui_down",
	},
	{
	0: "1button_left",
	1: "1button_right",
	2: "1button_up",
	3: "1button_down",
	}
]



func _ready():
	randomize()
	generate_arrow_presses()
#	for i in Stats.max_score:
#		Input_left.append(randi() % 4)
		
	display_correct_arrow()
	pass


		

func _process(_delta):
	#LEFT CHECK
	if !input_blocked:
		#IS the Input pressed for the left side?
		for i in int_button_dict.values():
			#which of the buttons of the left side where pressed iterate
			if Input.is_action_just_pressed(i):
				var next_press = int_button_dict[Input_left[0]]
				#is the next necessary press among them then:
				if Input.is_action_just_pressed(next_press):
					input_accomplished.append(Input_left.pop_front())
					increment()
	#				GameEvents.emit_signal("point_scored", self)
				else:#if wrong button! or elif but button still in the button_dict
					you_pressed_wrong_button()
					pass
	
	#interpolate amount of wine in Glass each frame
	$Tween.interpolate_property($Wine, 'margin_bottom', $Wine.margin_bottom,wine_fill_value,0.1,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()


func increment():
	
	if !inverted_flag:
		current_score = current_score + 1
	else:
		current_score = current_score - 1
		
	wine_fill_value = 9 + 62 /max_score * abs(current_score) #9 is min value and 62 is full value
	print(current_score, '    ', wine_fill_value)
	if current_score == max_score:
		invert()
#		win()
	elif current_score == 0 and inverted_flag == true:
		win()
#	elif current_score > max_score:
#		pass
	else:
		display_correct_arrow()

func win():
	#WIN PIZAZZ HERE
	
	
	#END
	$WinTimer.start()
	yield($WinTimer,"timeout")
	get_tree().change_scene('res://assets/StartScreen/StartScreen.tscn')
	pass

func generate_arrow_presses():
	while Input_left.size() < Stats.max_score:
		var new_num = randi() % 4
		if Input_left.size() == 0:
			Input_left.append(new_num)
		elif new_num != Input_left[-1]:
			Input_left.append(new_num)

func display_correct_arrow():
	var arrow_list = $Arrows.get_children()
	for i in arrow_list:
		i.visible = false
	arrow_list[Input_left[0]].visible = true
	pass

func invert():
	inverted_flag = true
	input_accomplished.invert()
	Input_left = input_accomplished
	pass

func you_pressed_wrong_button():
	$BlockTimer.start()
	input_blocked = true
	$xSprite.visible = true
	yield($BlockTimer,"timeout")
	input_blocked = false
	$xSprite.visible = false
	pass

func set_combo_meter():
	
