tool
extends Node
class_name State


var context
var next_state: State = null

func _on_ready() -> void:
  pass

func _update(_delta) -> void:
	pass

func _transition() -> State:
	return next_state

func _on_exit() -> void:
	pass