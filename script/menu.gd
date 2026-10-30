extends Control

@onready var menu_principal: Control = $"."
@onready var menu_parametre: Control = $"../menu_parametre"


func _on_texture_button_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/world_a_1.tscn")


func _on_texture_button_option_pressed() -> void:
	menu_principal.hide()
	menu_parametre.show()


func _on_texture_button_quit_pressed() -> void:
	get_tree().quit(0)
