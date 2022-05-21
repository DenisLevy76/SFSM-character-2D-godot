tool
extends Node
class_name State

var context

func _on_ready() -> void:
	pass

func _update(_delta) -> void:
	pass

func _transition() -> State:
	return context._current_state

func _on_exit() -> void:
	pass
