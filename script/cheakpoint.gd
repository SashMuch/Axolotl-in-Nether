extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		temp.checkpoint_position = $Marker2D.global_position
		temp.checkpoint_actif = true
