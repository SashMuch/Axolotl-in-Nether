extends CharacterBody2D

var ralentire = false
@export var SPEED = 300.0
const JUMP_VELOCITY = -300


@onready var animation_player: AnimationPlayer = $paramtre/animation/AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var cpu_particles_2d: CPUParticles2D = $Marker2D/CPUParticles2D
@onready var marker_2d: Marker2D = $Marker2D
@onready var ray_cast_2d: RayCast2D = $Marker2D/RayCast2D

func _process(delta):
	marker_2d.look_at(get_global_mouse_position())

	cpu_particles_2d.emitting = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if Input.is_action_just_pressed("ralentire") and ralentire == false:
		temp.vitesse = 0.2
		ralentire = true
		return
	if Input.is_action_just_pressed("ralentire") and ralentire == true:
		temp.vitesse = 1.0
		ralentire = false
		return
		
func _ready():
	ray_cast_2d.add_exception(self)
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("saut") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("gauche", "droite")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var temps_degats = 0.0

	marker_2d.look_at(get_global_mouse_position())

	var tire = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	cpu_particles_2d.emitting = tire

	temps_degats -= delta

	if tire and temps_degats <= 0:
		temps_degats = 0.2

		ray_cast_2d.force_raycast_update()

		if ray_cast_2d.is_colliding():
			var objet = ray_cast_2d.get_collider()

			if objet.has_method("prendre_degats"):
				objet.prendre_degats(1)
		
	animation_ubdate(direction)
	move_and_slide()
	
func animation_ubdate(dir):
	if velocity.y < 0:
		animation_player.play("saut montant") # Joue l'animation de saut en montée
		if dir == 1:
			sprite_2d.flip_h = false
		if dir == -1:
				sprite_2d.flip_h = true
	elif velocity.y > 0:
			animation_player.play("saut dessandant")
			if dir == 1:
				sprite_2d.flip_h = false
			if dir == -1:
				sprite_2d.flip_h = true
	else:
		if dir == 1:
			animation_player.play("marche")
			sprite_2d.flip_h = false
		if dir == -1:
			sprite_2d.flip_h = true
			animation_player.play("marche")
		if dir == 0:
			animation_player.play("RESET")
		
"""func _input(_event):
	if Input.is_action_just_pressed("ralentire") and ralentire == false:
		temp.vitesse = 0.2
		ralentire = true
		return
	if Input.is_action_just_pressed("ralentire") and ralentire == true:
		temp.vitesse = 1.0
		ralentire = false
		return"""
