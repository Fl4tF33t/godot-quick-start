@tool
class_name InitializeProject
extends EditorPlugin

const JSON_PATH: String = "res://addons/project_initialization/config.json"
const MENU_ITEM: String = "Initialize Project"
const TOOL_SCENE: PackedScene = preload("res://addons/project_initialization/project_initialization.tscn")

var tool_window: Window

func _enable_plugin() -> void:
	remove_tool_menu_item(MENU_ITEM)
	add_tool_menu_item(MENU_ITEM, _open_window)

func _disable_plugin() -> void:
	remove_tool_menu_item(MENU_ITEM)

func _enter_tree() -> void:
	_enable_plugin()

func _exit_tree() -> void:
	_disable_plugin()
	if is_instance_valid(tool_window):
		tool_window.queue_free()
		tool_window = null

func _open_window() -> void:
    # If the window already exists, just show it.
	if is_instance_valid(tool_window):
		tool_window.popup_centered()
		return

    # Create the window.
	tool_window = Window.new()
	tool_window.title = MENU_ITEM
	tool_window.size = Vector2i(400, 200)

    # Window settings.
	tool_window.unresizable = true
	tool_window.close_requested.connect(_on_window_close)

    # Add the UI.
	var tool: Control = TOOL_SCENE.instantiate()
	tool_window.add_child(tool)

    # Register the window with the editor.
	EditorInterface.popup_dialog_centered(tool_window)

func _on_window_close() -> void:
	if is_instance_valid(tool_window):
		tool_window.queue_free()
		tool_window = null

static func get_json_data(key: String) -> Variant:
	var file = FileAccess.open(JSON_PATH, FileAccess.READ)

	if file == null:
		push_error("Could not open configuration.")
		return null

	var json = JSON.new()
	var error = json.parse(file.get_as_text())

	if error != OK:
		push_error("JSON error: " + json.get_error_message())
		return null

	var data = json.data

	if not data is Dictionary or not data.has(key):
		push_error("Invalid configuration.")
		return null

	return data[key]