extends CharacterBody2D

@export var player:CharacterBody2D
@export var speed:float
@export var hp:float

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if hp <= 0:
		queue_free()
	
	var direction := player.position - position
	rotation = direction.angle()
	
	velocity = direction.normalized() * speed
	move_and_slide()
