extends Control

@onready var menu_principal: Control = $"../menu_principal"
@onready var menu_parametre: Control = $"."



func _on_texture_button__retoure_pressed() -> void:
	menu_principal.show()
	menu_parametre.hide()


func _on_texture_button_son_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)
