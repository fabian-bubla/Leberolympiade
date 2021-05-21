tool
class_name JsonDock
extends PanelContainer

const TYPE_COL := 0
const KEY_COL := 1
const VALUE_COL := 2
#TYPES IS AN ARRAY OF DICTIONARIES containing a name object and another object default val which can be a dictionary list etc.
const TYPES := [
	{
		name = "Object",
		default_val = {},
	},
#	{
#		name = "Array",
#		default_val = [],
#	},
#	{
#		name = "String",
#		default_val = "",
#	},
#	{
#		name = "Number",
#		default_val = 0,
#	},
#	{
#		name = "Boolean", #Fixme
#		default_val = false,
#	},
#	{
#		name = "Null",
#		default_val = null,
#	},
	{
		name = "person",
		default_val = "Player",
	},
	{
		name = "text",
		default_val = "",
	},
	{
		name = "voicebox",
		default_val = true,
	},
	{
		name = "pitch",
		default_val = "4",
	},
	{
		name = "char_time",
		default_val = "0",
	},
	{
		name = "wait_time",
		default_val = "3",
	},
	{
		name = "font",
		default_val = "Lato",
	},
	{
		name = "font_color",
		default_val = "#000000",
	},
	{
		name = "font_size",
		default_val = "",
	},
	{
		name = "func",
		default_val = "",
	},
	{
		name = "args",
		default_val = [],
	},
	{
	name = "add_knot",
	default_val = "",
	},
	{
	name = "erase_knot",
	default_val = "",
	},
]
#"voicebox":
#			pass
#		"pitch":
#			pass
#		"char_time":
#			pass
#		"wait_time":
#			pass
#		"font":
#			pass
#		"font_color":
#			pass
#		"font_size":
#			pass
#		"func":
#			pass
#		"args":
#			pass
const INDENTATIONS := [
	{
		name = "2 wide spaces",
		indent = "  ",
	},
	{
		name = "4 wide spaces",
		indent = "    ",
	},
	{
		name = "8 wide spaces",
		indent = "        ",
	},
	{
		name = "tabs",
		indent = "	",
	},
	{
		name = "no formatting",
		indent = "",
	},
]

var select_file_dialog: EditorFileDialog
onready var settings: PopupPanel = get_node("Settings")
onready var close_file_confirmation: ConfirmationDialog = get_node("Close File Confirmation")
onready var error_dialog: AcceptDialog = get_node("Error Dialog")

onready var file_name: Label = get_node("VBoxContainer/Tools/Left/File Name")
onready var tree: Tree = get_node("VBoxContainer/Tree")
var bubble_icon = load("res://addons/Dialogue/Speech_bubble.svg")

var opened_path: String
var indentation_idx: int = 0
var auto_parenting: bool = true

func _input(event):
	pass
func _gui_input(event):
	if event.is_action_pressed("ui_accept"):
		print('woah')
#		_remove_selected_element()
#    if event is InputEvent:
#	    if event.button_index == BUTTON_LEFT and event.pressed:
#	        print("I've been clicked D:")
#	pass

func _ready() -> void:
	name = "Dialogue"
	
	var indentation_option: OptionButton = get_node("Settings/VSplitContainer/Contents/Indentation/OptionButton")
	indentation_option.clear()
	for i in range(0, INDENTATIONS.size()):
		indentation_option.add_item(INDENTATIONS[i].name, i)
	
	var add_element_button: MenuButton = get_node("VBoxContainer/Tree Manipulation Tools/Add Entry")
#	var add_menu_button: MenuButton = get_node("VBoxContainer/Tree Manipulation Tools/MenuButton") #I ADDED THIS FIXME
	for i in range(0, TYPES.size()):
		add_element_button.get_popup().add_item(TYPES[i].name, i)
	add_element_button.get_popup().connect("id_pressed", self, "_add_element")

#	for i in range(0, TYPES.size()):
#		add_menu_button.get_popup().add_item(TYPES[i].name, i)
#	add_menu_button.get_popup().connect("id_pressed", self, "_add_element")
	
	#Column SIZES
	tree.columns = 3
	tree.set_column_expand(0,3)
	tree.set_column_min_width(0,2)
	
	tree.set_column_expand(1,true)
	tree.set_column_min_width(1,2)

	tree.set_column_expand(2,true)
	tree.set_column_min_width(2,4)

	select_file_dialog.connect("file_selected", self, "_open_file")

func _request_open_file() -> void:
	if not opened_path.empty():
		error_dialog.dialog_text = "A file is already open. Please close the current file before opening a new one."
		error_dialog.popup_centered()
		return
	select_file_dialog.popup_centered_ratio()

func _open_file(file_path: String) -> void:
	var file := File.new()
	var file_open_err := file.open(file_path, File.READ)
	if file_open_err != OK:
		show_error("Error while trying to open JSON file %s. Error code: %d" % [file_path, file_open_err])
		return
	
	var parse_result := JSON.parse(file.get_as_text())
	if parse_result.error != OK:
		show_error("Loaded invalid JSON file from %s, please fix syntax errors before loading with this plugin." % file_path)
		return
	file.close()
	
	opened_path = file_path
	file_name.text = select_file_dialog.current_file
	
	var root = parse_result.result
	match typeof(root):
		TYPE_DICTIONARY:
			_gen_object(root as Dictionary, "", false)
		TYPE_ARRAY:
			_gen_array(root as Array, "", false)
		TYPE_STRING:
			_gen_item(null, "String", root)
		TYPE_BOOL:
			_gen_item(null, "Boolean", root)
		TYPE_REAL:
			_gen_item(null, "Number", root)
		_:
			_gen_item(null, "Null", null)

func _gen_object(node: Dictionary, node_key: String = "", has_key: bool = false, parent: Object = null, type_override = null) -> void:
	var object := tree.create_item(parent)
	
	object.set_cell_mode(TYPE_COL, TreeItem.CELL_MODE_STRING)
#	if type_override == "Bubble" or node_key.is_valid_integer():
#		object.set_cell_mode(TYPE_COL, TreeItem.CELL_MODE_ICON)
#		object.set_icon(TYPE_COL,bubble_icon ) #Bubble Icon
#		object.set_icon_max_width(TYPE_COL, 30) #Bubble Icon
###		print('icon ' + str(object.get_icon(0)))
##
#	else:
#		object.set_text(TYPE_COL, "Object")
	object.set_text(TYPE_COL, "Object")
	
	if has_key:
		object.set_cell_mode(KEY_COL, TreeItem.CELL_MODE_STRING)
		object.set_text(KEY_COL, node_key)
		object.set_editable(KEY_COL, true)
	
	for dict_key in node.keys(): #iterate through the keys of the dictionary only, so for all thingies in that enum create
		var key := dict_key as String
		var value = node[key] #match the value to what kind of thing is in this variable
		match typeof(value):
			TYPE_DICTIONARY: #Godot intern
				_gen_object(value as Dictionary, key, true, object) #as is cast value to given type if possible
			TYPE_ARRAY:
				_gen_array(value as Array, key, true, object)
			TYPE_STRING:
				_gen_item(object, "String", value, key, true)
			TYPE_BOOL:
				_gen_item(object, "Boolean", value, key, true)
			TYPE_REAL:
				_gen_item(object, "Number", value, key, true)
			_:
				_gen_item(object, "Null", null, key, true)

func _gen_array(node: Array, node_key: String = "", has_key: bool = false, parent: Object = null) -> void:
	var array := tree.create_item(parent)
	
	array.set_cell_mode(TYPE_COL, TreeItem.CELL_MODE_STRING)
	array.set_text(TYPE_COL, "Array")
#	array.set_text(KEY_COL, "2") #this one doesn't show this is where the ITEMS inside the array would go
#	array.set_text(VALUE_COL, "3") #this one shows.
	if has_key:
		array.set_cell_mode(KEY_COL, TreeItem.CELL_MODE_STRING)
		array.set_text(KEY_COL, node_key)
		array.set_editable(KEY_COL, true)
	
	for value in node:
		match typeof(value):
			TYPE_DICTIONARY:
				_gen_object(value as Dictionary, "", false, array)
			TYPE_ARRAY:
				_gen_array(value as Array, "", false, array)
			TYPE_STRING:
				_gen_item(array, "String", value)
			TYPE_BOOL:
				_gen_item(array, "Boolean", value)
			TYPE_REAL:
				_gen_item(array, "Number", value)
			_:
				_gen_item(array, "Null", null)

func _gen_item(parent: TreeItem, type: String, value, key: String = "", has_key: bool = false, color: Color = Color(0,0,0,0)):
	var item := tree.create_item(parent)
	item.set_cell_mode(TYPE_COL, TreeItem.CELL_MODE_STRING)
	item.set_text(TYPE_COL, type)
	if has_key:
		item.set_text(KEY_COL, key)
		item.set_editable(KEY_COL, true)
	item.set_cell_mode(VALUE_COL, TreeItem.CELL_MODE_STRING)
	item.set_text(VALUE_COL, str(value))
	item.set_editable(VALUE_COL, true)
	
	if color:
		for col in range(0,3):
			item.set_custom_bg_color(col, color)
#	return item

func _request_save_file() -> void:
	if opened_path.empty():
		return
	
	var file := File.new()
	if file.open(opened_path, File.WRITE) != OK:
		show_error("Error while trying to open JSON file %s." % opened_path)
		return
	var json := _reconstruct_object(tree.get_root())
	var indent: String = INDENTATIONS[indentation_idx].indent
	file.store_string(JSON.print(json, indent))
	file.close()

func _reconstruct_object(node: TreeItem) -> Dictionary:
	var result := {}
	var child := node.get_children()
	while child:
		var key := child.get_text(KEY_COL)
		match child.get_text(TYPE_COL):
			"Object":
				result[key] = _reconstruct_object(child)
			"Bubble":
				result[key] = _reconstruct_object(child)
			"Array":
				result[key] = _reconstruct_array(child)
			"String":
				result[key] = child.get_text(VALUE_COL)
			"Number":
				result[key] = int(child.get_text(VALUE_COL))
			"Boolean":
				result[key] = bool(child.get_text(VALUE_COL))
			"person":
				result[key] = child.get_text(VALUE_COL)
			"text":
				result[key] = child.get_text(VALUE_COL)
			"voicebox":
				result[key] = child.get_text(VALUE_COL)
			"pitch":
				result[key] = child.get_text(VALUE_COL)
			"char_time":
				result[key] = child.get_text(VALUE_COL)
			"wait_time":
				result[key] = child.get_text(VALUE_COL)
			"font":
				result[key] = child.get_text(VALUE_COL)
			"font_color":
				result[key] = child.get_text(VALUE_COL)
			"font_size":
				result[key] = child.get_text(VALUE_COL)
			"func":
				result[key] = child.get_text(VALUE_COL)
			"args":
				result[key] = _reconstruct_array(child)
			"add_knot":
				result[key] = child.get_text(VALUE_COL)
			"erase_knot":
				result[key] = child.get_text(VALUE_COL)
			"Null":
				result[key] = null
		child = child.get_next()
	return result

func _reconstruct_array(node: TreeItem) -> Array:
	var result := []
	var child := node.get_children()
	while child:
		match child.get_text(TYPE_COL):
			"Object":
				result.append(_reconstruct_object(child))
			"Bubble":
				result.append(_reconstruct_object(child))
			"Array":
				result.append(_reconstruct_array(child))
			"String":
				result.append(child.get_text(VALUE_COL))
			"Number":
				result.append(int(child.get_text(VALUE_COL)))
			"Boolean":
				result.append(bool(child.get_text(VALUE_COL)))
			"Null":
				result.append(null)
		child = child.get_next()
	return result

func _request_close_file() -> void:
	if not opened_path.empty():
		close_file_confirmation.popup_centered()

func _close_file() -> void:
	opened_path = ""
	file_name.text = ""
	tree.clear()
	

func show_error(msg: String) -> void:
	push_error(msg)
	error_dialog.dialog_text = msg
	error_dialog.popup_centered()

func _close_settings() -> void:
	settings.visible = false

func _open_settings() -> void:
	settings.popup_centered()

func _select_indentation(id: int) -> void:
	indentation_idx = id

func _set_auto_parenting_option(pressed: bool) -> void:
	auto_parenting = pressed

func _add_element(id: int, parent: TreeItem = null) -> void:
	var sel := tree.get_selected() if parent == null else parent
	if sel == null:
		return
	
	var key: String
	var has_key := false
	match sel.get_text(TYPE_COL):
		"Object":
			key = ""
			has_key = true
		"Array":
			has_key = false
		_:
			if auto_parenting:
				# auto-parenting result
				var apr: TreeItem = sel
				while apr != null:
					var type := apr.get_text(TYPE_COL)
					if type == "Object" or type == "Array":
						break
					apr = apr.get_parent()
				_add_element(id, apr)
			else:
				show_error("Cannot add to a non-container element!")
			return
	
	var type: String = TYPES[id].name
	var default_val = TYPES[id].default_val
	match type:
		"Object":
			_gen_object(default_val, key, has_key, sel)
		"Array":
			_gen_array(default_val, key, has_key, sel)
		"Bubble":
			_gen_object(default_val, key, has_key, sel) #Maybe add type override bubble?
		"person":
			_gen_item(sel, type, default_val, type, has_key) # Color.darkgray
		"text":
			_gen_item(sel, type, default_val, type, has_key) # , Color.darkgray
		"voicebox":
			_gen_item(sel, type, default_val, type, has_key)
		"pitch":
			_gen_item(sel, type, default_val, type, has_key)
		"char_time":
			_gen_item(sel, type, default_val, type, has_key)
		"wait_time":
			_gen_item(sel, type, default_val, type, has_key)
		"font":
			_gen_item(sel, type, default_val, type, has_key)
		"font_color":
			_gen_item(sel, type, default_val, type, has_key)
		"font_size":
			_gen_item(sel, type, default_val, type, has_key)
		"func":
			_gen_item(sel, type, default_val, type, has_key)
		"args":
			_gen_array(default_val, key, has_key, sel)
		"add_knot":
			_gen_item(sel, type, default_val, type, has_key)
		"erase_knot":
			_gen_item(sel, type, default_val, type, has_key)
		_:
			_gen_item(sel, type, default_val, key, has_key)
		

func _remove_selected_element() -> void:
	while true:
		var sel = tree.get_next_selected(null)
		if sel == null:
			break
		var parent = sel.get_parent()
		if parent == null:
			show_error("Cannot remove the root node!")
		else:
			parent.remove_child(sel)

func _copy_selected_elements() -> void:
	pass

func _on_NewBubble_pressed(parent: TreeItem = null) -> void:
	
	#THIS SHOULD ONLY WORK IF CONV LEVEL IS SELECTED!
	var sel := tree.get_selected() 
	var default_val = TYPES[0].default_val # 0 is the 'id' which selects the Object braces
	var key =  0 #key is the name and should just be the previous +1 later on
	var has_key = true #has key is true for objects and makes the key prob editable
	
	#CHOOSE BUBBLE NR
	if sel.get_children() == null:
		key = "0"
	else:
		var bubble_sel = sel.get_children()
		while true:
			key += 1
			if bubble_sel.get_next() == null:
				break
			bubble_sel = bubble_sel.get_next()


	_gen_object(default_val, str(key), has_key, sel) #, "Bubble"
	
	
	#GOES into its children and then iterates until its at the last one!
	sel = sel.get_children()
	while true:
		if sel.get_next() == null:
			break
		sel = sel.get_next()
	
	#____________________________________________
		#GENERATING A PERSON OR TEXT STRING OBJECT beneath selected object
#	sel = sel.get_next()
#	for i in range(2): #loop only works if I remove return statement from generate item
	var type: String = 'String' #usually TYPES[id].name
	key = "person" #key goes into the key column #HIT for adding person/text into datafile automatically use this
	var value = 'Player' #this goes in the value column #HIT
	has_key = true #makes key column visible and editable and sets text therein
	_gen_item(sel, type, value, key, has_key) #Color.darkgray
	
	
	type= 'String' #usually TYPES[id].name
	key = "text" #key goes into the key column #HIT for adding person/text into datafile automatically use this
	value = '' #this goes in the value column #HIT
	has_key = true #makes key column visible and editable and sets text therein
	_gen_item(sel, type, value, key, has_key) #Color.darkgray
#	_gen_item(sel, 'man', default_val, type, has_key, Color.beige)
#	var id = 0 #this doesn't belong here
#	match sel.get_text(TYPE_COL):
#		"Object":
#			key = ""
#			has_key = true
#		"Array":
#			has_key = false
#		_:
#			if auto_parenting:
				# auto-parenting result



		
		
#	var previous_item = sel.get_prev()
#	print(previous_item.get_text(KEY_COL))
	
#	if previous_item == null:
#		key = '0'
#	elif sel.get_text(KEY_COL) == '0':
#		key = '1'
#	else:
#		var temp = previous_item.get_text(KEY_COL)
#		key = str(int(key)+1)
	#previous_item.get_value or column2
	
#	sel = sel.get_parent()
	
	
#	type = 'String' #usually TYPES[id].name
#	key = "text" #key goes into the key column #HIT for adding person/text into datafile automatically use this
#	value = 'hello!' #this goes in the value column #HIT
#	has_key = true #makes key column visible and editable and sets text therein
#	_gen_strange_item(sel, type, value, key, has_key)
#	var id = 0
#
#	var sel := tree.get_selected() if parent == null else parent
#	if sel == null:
#		return
#
#	var key: String
#	var has_key := false
#
#	match sel.get_text(TYPE_COL):
#		"Object":
#			key = ""
#			has_key = true
#		"Array":
#			has_key = false
#		_:
#			if auto_parenting:
#				# auto-parenting result
#				var apr: TreeItem = sel
#				while apr != null:
#					var type := apr.get_text(TYPE_COL)
#					if type == "Object" or type == "Array":
#						break
#					apr = apr.get_parent()
#				_add_element(id, apr)
#			else:
#				show_error("Cannot add to a non-container element!")
#			return
#
#	var type: String = TYPES[id].name
#	var default_val = TYPES[id].default_val
#	match type:
#		"Object":
#			_gen_object(default_val, key, has_key, sel)
#		"Array":
#			_gen_array(default_val, key, has_key, sel)
#		_:
#			_gen_item(sel, type, default_val, key, has_key)
#
#
	pass # Replace with function body.

func _gen_strange_item(parent: TreeItem, type: String, value, key: String = "", has_key: bool = false) -> TreeItem:
	var item := tree.create_item(parent)
	item.set_cell_mode(TYPE_COL, TreeItem.CELL_MODE_STRING)
	
	
	item.set_custom_color(KEY_COL, Color('#575757'))
	
#	item.set_custom_color(KEY_COL,Color('white'))
#	item.set_text(TYPE_COL, type)


	if has_key:
		item.set_text(KEY_COL, key) #if haskey true then key column sets some text and is editable
		item.set_editable(KEY_COL, true)
	item.set_cell_mode(VALUE_COL, TreeItem.CELL_MODE_STRING)
	item.set_text(VALUE_COL, str(value))
	item.set_editable(VALUE_COL, true)
	return item


func _on_NewConv_pressed():
	var sel := tree.get_selected() 
	var default_val = TYPES[0].default_val # 0 is the 'id' which selects the Object braces
	var key =  0 #key is the name and should just be the previous +1 later on
	var has_key = true #has key is true for objects and makes the key prob editable
	
	#CHOOSE BUBBLE NR
	if sel.get_children() == null:
		key = "0"
	else:
		var bubble_sel = sel.get_children()
		while true:
			key += 1
			if bubble_sel.get_next() == null:
				break
			bubble_sel = bubble_sel.get_next()


	_gen_object(default_val, 'Conv' + str(key), has_key, sel, "Conversation")


func _on_NewCharacter_pressed():
	var sel := tree.get_selected() 
	var default_val = TYPES[0].default_val # 0 is the 'id' which selects the Object braces
	var key =  0 #key is the name and should just be the previous +1 later on
	var has_key = true #has key is true for objects and makes the key prob editable
	
	_gen_object(default_val, "", has_key, sel, "Char")
	pass # Replace with function body.


func _on_MenuButton_pressed():
	pass # Replace with function body.



func _on_HSlider_value_changed(value):
	var selected_column = $VBoxContainer/Tools/Left/OptionButton.get_selected_id()
#	tree.set_column_expand(2,true)
	tree.set_column_min_width(selected_column,value)
	pass # Replace with function body.


func _on_Next_pressed():
	var sel := tree.get_selected()
	sel = sel.get_next()
	
	pass # Replace with function body.


func _on_Previous_pressed():
	var sel := tree.get_selected()
	sel = sel.get_prev()
	pass # Replace with function body.
