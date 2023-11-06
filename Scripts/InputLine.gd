extends LineEdit


func _on_focus_entered() -> void:
	$AnimationPlayer.play("Scale")


func _on_focus_exited() -> void:
	$AnimationPlayer.play_backwards("Scale")
