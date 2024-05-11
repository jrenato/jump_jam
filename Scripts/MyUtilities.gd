extends Node


func add_log_msg(log_str: String) -> void:
	var console: Control = get_tree().get_first_node_in_group("debug_console")

	if console:
		var log_label = console.find_child("LogLabel")
		if log_label:
			log_label.text += "%s\n" % log_str
