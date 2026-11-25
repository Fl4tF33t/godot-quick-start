@tool
class_name InitializeProject
extends EditorPlugin

const JSON_PATH: String = "res://addons/project_initialization/config.json"
const MENU_ITEM: String = "Initialize Project"
const TOOL_SCENE: PackedScene = preload("res://addons/project_initialization/project_initialization.tscn")

var dock: EditorDock

func _enable_plugin() -> void:
	add_tool_menu_item(MENU_ITEM, _open_tool)

func _disable_plugin() -> void:
	remove_tool_menu_item(MENU_ITEM)

func _open_tool() -> void:
	# If the dock already exists, just show it.
	if is_instance_valid(dock):
		dock.make_visible()
		return

	# Create the dock.
	dock = EditorDock.new()
	dock.title = MENU_ITEM
	dock.default_slot = EditorDock.DOCK_SLOT_LEFT_UL

	# Optional settings for a temporary utility dock.
	dock.transient = true
	dock.global = false
	dock.closable = true

	# Add the UI.
	var tool: Control = TOOL_SCENE.instantiate()
	dock.add_child(tool)

	# Register the dock with the editor.
	add_dock(dock)
	dock.make_visible()


func _exit_tree() -> void:
	if is_instance_valid(dock):
		remove_dock(dock)
		dock.queue_free()

	dock = null

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