extends CharacterBody2D

var speed = 2000
var direction = 1
var vie = 100
const JUMP_VELOCITY = -200
@export var special = true
var player_entered = false
var speed_dash = 300
var direction_dash: Vector2 = Vector2.ZERO
var dashing = false
var can_dash = true
var souris_dans_zone = false
@export var special_color : Color

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var position_initiale = sprite_2d.position
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var joueur = get_tree().get_first_node_in_group("player")
@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2
@onready var timer_3: Timer = $Timer3


func _ready() -> void:
	print(special)
	if special:
		speed = 3000
		vie = 200
		sprite_2d.modulate = special_color

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * temp.vitesse
	
	if player_entered and souris_dans_zone and not dashing and can_dash and special:
		sprite_2d.position = position_initiale + Vector2(
		randf_range(-1, 1),
		randf_range(-1, 1)
		)
		velocity.x = 0
		if timer.is_stopped():
			timer.start()

	elif dashing == true and special:
		if timer_2.is_stopped():
			timer_2.start()
		velocity = direction_dash * speed_dash * temp.vitesse
		sprite_2d.position = position_initiale
		
	else:
		set_direction()
		velocity.x = direction * speed * delta * temp.vitesse
		sprite_2d.position = position_initiale
		
	move_and_slide()
		
		

func set_direction():
	if is_instance_valid(ray_cast_2d.get_collider()):
		var collide = ray_cast_2d.get_collider()
		if collide.is_in_group("tilemap"):
			if direction == 1:
				direction = -1
				ray_cast_2d.target_position = Vector2(-16,0)
				sprite_2d.flip_h = true
			else:
				direction = 1
				ray_cast_2d.target_position = Vector2(16,0)
				sprite_2d.flip_h = false


func _on_area_2d_kill_body_entered(body: Node2D) -> void:
	if body.name == "player":
		get_tree().reload_current_scene.call_deferred()

func prendre_degats(degats):
	vie -= degats

	#print("Vie de l'ennemi :", vie)

	if vie <= 0:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
		if body.name == "player":
			player_entered = true


func _on_timer_timeout() -> void:
	if player_entered and can_dash and is_instance_valid(joueur):
		direction_dash = global_position.direction_to(joueur.global_position)
		dashing = true


func _on_timer_2_timeout() -> void:
	if timer_3.is_stopped():
		timer_3.start()
	dashing = false
	can_dash = false


func _on_timer_3_timeout() -> void:
	can_dash = true
	return



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player":
			player_entered = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("souris"):
		souris_dans_zone = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("souris"):
		souris_dans_zone = false
