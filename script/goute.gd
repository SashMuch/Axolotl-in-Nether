extends Area2D

var direction = Vector2.RIGHT
var vitesse = 300
var degats = 1
var velocity = Vector2.ZERO
var gravite = 300


func _ready():
	velocity = direction * vitesse
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(randf_range(0.2, 0.4)).timeout.connect(queue_free)


func _physics_process(delta):
	velocity.y += gravite * delta
	global_position += velocity * delta

func _on_body_entered(body):
	if body.has_method("prendre_degats"):
		body.prendre_degats(degats)

	queue_free()
