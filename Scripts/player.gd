extends CharacterBody2D

var BULLET := preload("res://Scenes/player_bullet.tscn")
@onready var TIMER := $Timer

@export_category("Stats")
@export var total_points:int = 0
@export var hp:int = 100
@export var speed:float = 300
@export var speed_mult:float = 1
@export var rate_of_fire:float = 1
@export var bullet_speed:float = 150
@export var bullet_speed_mult:float = 1
@export var bullet_range:float = 0.75
@export var bullet_damage:float = 1

@export_category("UI")
@export var hp_label:Label
@export var points_label:Label
@export var gameover_screen:Control

func _ready() -> void:
	SignalBus.enemy_died.connect(_on_enemy_died)

func _physics_process(delta: float) -> void:
	move()
	aim()
	
	if Input.is_action_just_pressed("debug_slow_rof"):
		rate_of_fire = rate_of_fire/2
		change_shoot_timer(rate_of_fire)

func _process(delta: float) -> void:
	update_ui_stats()

func move():
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionx := Input.get_axis("move_left", "move_right")
	var directiony := Input.get_axis("move_up", "move_down")
	var direction := Vector2(directionx, directiony)
	if direction:
		velocity = direction.normalized() * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	
func aim():
	var aim_x := Input.get_axis("aim_left", "aim_right")
	var aim_y := Input.get_axis("aim_up", "aim_down")
	var aim := Vector2(aim_x, aim_y)
	if aim:
		rotation = aim.angle()

func shoot():
	var bullet_instance = BULLET.instantiate()
	bullet_instance.global_position = $Barrel.global_position
	bullet_instance.global_rotation = $Barrel.global_rotation
	bullet_instance.speed = bullet_speed
	bullet_instance.range = bullet_range
	bullet_instance.damage = bullet_damage
	get_parent().add_child(bullet_instance)

func hurt(damage:int):
	hp -= damage
	if hp <= 0:
		die()

func die():
	print("dead")
	gameover_screen.visible = true

func _on_enemy_died(points):
	total_points += points

func _on_timer_timeout():
	shoot()

func change_shoot_timer(new_rate:float):
	TIMER.stop()
	TIMER.wait_time = new_rate
	TIMER.start()

func update_ui_stats():
	hp_label.text = "HP: " + str(hp)
	points_label.text = "Score: " +str(total_points)
