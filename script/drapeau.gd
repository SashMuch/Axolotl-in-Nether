extends Area2D

@export var scene : String
@export var hide_sprite = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	if !hide_sprite:
		animated_sprite_2d.play("idle")
		animated_sprite_2d.visible = true


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		print("salut")
		get_tree().change_scene_to_file(scene)
