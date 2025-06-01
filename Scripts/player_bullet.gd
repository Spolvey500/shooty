extends RigidBody2D

@export var TIMER:Timer

var range:float
var speed:float
var damage:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_central_impulse(Vector2.from_angle(global_rotation) * speed)
	TIMER.wait_time = range
	TIMER.start(range)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	print("bullet collided")
	
	if body.is_in_group("Enemies"):
		body.hp -= damage
	
	queue_free()
