@tool
extends Button

const PROJECT_SETTINGS: String = "project_settings"
const EDITOR_SETTINGS: String = "editor_settings"

func _ready() -> void:
	pressed.connect(_configure_settings)

func _exit_tree() -> void:
	pressed.disconnect(_configure_settings)

func _configure_settings() -> void:
	print("Configuring Project and Editor Settings...")
	_project_settings()
	_editor_settings()

func _project_settings() -> void:
	var data = InitializeProject.get_json_data(PROJECT_SETTINGS)

	for key in data.keys():
		var value = data[key]
		if key == null or value == null:
			push_error("Invalid key or value in project settings: %s = %s" % [str(key), str(value)])
			continue

		ProjectSettings.set_setting(key, value)
		print("Set %s to %s" % [key, str(value)])

	ProjectSettings.save()

func _editor_settings() -> void:
	var settings := EditorInterface.get_editor_settings()
	var data = InitializeProject.get_json_data(EDITOR_SETTINGS)

	for key in data.keys():
		var value = data[key]
		if key == null or value == null:
			push_error("Invalid key or value in editor settings: %s = %s" % [str(key), str(value)])
			continue

		settings.set_setting(key, value)
		print("Set %s to %s" % [key, str(value)])