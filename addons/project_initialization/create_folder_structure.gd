@tool
extends Button

const FOLDERS: String = "folders"

func _ready() -> void:
	pressed.connect(_create_folder_structure)

func _exit_tree() -> void:
	pressed.disconnect(_create_folder_structure)

func _create_folder_structure() -> void:
	var data = InitializeProject.get_json_data(FOLDERS)

	for folder in data:
		if not folder is String:
			continue

		var path = "res://" + folder

		var dir_error = DirAccess.make_dir_recursive_absolute(
			ProjectSettings.globalize_path(path)
		)

		if dir_error != OK:
			push_error("Failed to create %s: %s" % [path, error_string(dir_error)])
		else:
			print("Created or verified: ", path)

	EditorInterface.get_resource_filesystem().scan()
