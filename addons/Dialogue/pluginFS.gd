tool
extends EditorPlugin

var select_file_dialog: EditorFileDialog
var dock: JsonDock

func _enter_tree() -> void:
	var base := get_editor_interface().get_base_control()

	select_file_dialog = EditorFileDialog.new()
	select_file_dialog.add_filter("*.json")
	select_file_dialog.mode = EditorFileDialog.MODE_OPEN_FILE
	base.add_child(select_file_dialog)

	dock = preload("res://addons/Dialogue/json_dock.tscn").instance()
	dock.select_file_dialog = select_file_dialog
	get_editor_interface().get_editor_viewport().add_child(dock)
	make_visible(false)

func has_main_screen():
	return true

func make_visible(visible):
	if dock:
		dock.visible = visible

func _exit_tree() -> void:
	dock.free()
	select_file_dialog.free()

func get_plugin_name():
	return "Dialogue"

func get_plugin_icon():
	return load('res://addons/Dialogue/Dialogue.svg')
#	return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
