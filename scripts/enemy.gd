class_name Enemy
extends Node2D
## Act-1 enemy base: hp, hit circle, score value, and a bullet pool to fire
## into. Patterns are tiny explicit state machines stepped by hand (no
## physics) so tests/replays are deterministic.
## Types (spec act 1): FighterStraight (hp 1, dives from the top, fires a
## single aimed shot on a timer) and BomberSlow (hp 4, slow sine drift across,
## drops a 3-shot spread downward).

signal died(enemy: Enemy)

var kind := "fighter"
var hp := Feel.FIGHTER_HP
var radius := Feel.FIGHTER_RADIUS
var score_value := Feel.FIGHTER_SCORE
var alive := true
var shots_fired := 0

var pool: BulletPool = null   # enemy bullet pool (injected by Stage)
var target: Node2D = null     # player plane, for aimed shots (may be null)

const ST_DIVE := 0
const ST_FIRE := 1


func _init(enemy_kind := "fighter") -> void:
	kind = enemy_kind
	match kind:
		"bomber":
			hp = Feel.BOMBER_HP
			radius = Feel.BOMBER_RADIUS
			score_value = Feel.BOMBER_SCORE
			_build_sprite("res://assets/generated/enemy_bomber.png", Feel.BOMBER_SPRITE_SCALE)
		_:
			hp = Feel.FIGHTER_HP
			radius = Feel.FIGHTER_RADIUS
			score_value = Feel.FIGHTER_SCORE
			_build_sprite("res://assets/generated/enemy_fighter.png", Feel.FIGHTER_SPRITE_SCALE)


func _build_sprite(path: String, sprite_scale: float) -> void:
	if not ResourceLoader.exists(path):
		return
	var spr := Sprite2D.new()
	spr.texture = load(path)
	spr.scale = Vector2.ONE * sprite_scale
	spr.rotation = PI  # art faces up; these fly down/across
	add_child(spr)


## One frame of behaviour. Virtual.
func step(_delta: float) -> void:
	pass


## Returns true when this hit killed the enemy.
func take_damage(amount: int) -> bool:
	if not alive:
		return false
	hp -= amount
	if hp <= 0:
		alive = false
		died.emit(self)
		return true
	return false


## Off-screen cleanup check, called by the Stage after stepping.
func escaped() -> bool:
	var view := get_viewport_rect().size
	var m := Feel.BULLET_OFFSCREEN_MARGIN_PX + radius
	return position.y > view.y + m or position.y < -m * 3.0 \
			or position.x < -m or position.x > view.x + m


func _fire(dir: Vector2, speed: float) -> void:
	if pool == null:
		return
	if pool.spawn(global_position, dir.normalized() * speed,
			Feel.ENEMY_BULLET_DAMAGE, Feel.ENEMY_BULLET_RADIUS, false) != null:
		shots_fired += 1


## ------------------------------------------------------------------ types --

class FighterStraight:
	extends Enemy
	## Dives from the top; on a timer snaps into a brief FIRE beat that looses
	## one aimed shot at the player, then back to diving.

	var state := ST_DIVE
	var state_time := 0.0
	var fire_timer := Feel.FIGHTER_FIRST_FIRE_DELAY

	func _init() -> void:
		super("fighter")

	func step(delta: float) -> void:
		state_time += delta
		position.y += Feel.FIGHTER_SPEED * delta
		match state:
			ST_DIVE:
				fire_timer -= delta
				if fire_timer <= 0.0:
					state = ST_FIRE
					state_time = 0.0
					_fire_aimed()
			ST_FIRE:
				if state_time >= Feel.FIGHTER_FIRE_STATE_SEC:
					state = ST_DIVE
					state_time = 0.0
					fire_timer = Feel.FIGHTER_FIRE_INTERVAL

	func _fire_aimed() -> void:
		var dir := Vector2.DOWN
		if target != null and is_instance_valid(target):
			dir = target.global_position - global_position
		_fire(dir, Feel.ENEMY_BULLET_SPEED)


class BomberSlow:
	extends Enemy
	## Slow sine drift across the screen; drops a 3-shot spread downward on a
	## timer. y(t) integrates the sine derivative so the drift is smooth and
	## deterministic.

	var dir_x := 1.0
	var drift_t := 0.0
	var fire_timer := Feel.BOMBER_FIRST_FIRE_DELAY
	var min_y := 1e12
	var max_y := -1e12

	func _init() -> void:
		super("bomber")

	func step(delta: float) -> void:
		drift_t += delta
		position.x += dir_x * Feel.BOMBER_SPEED * delta
		position.y += cos(drift_t * Feel.BOMBER_SINE_RAD_PER_SEC) \
				* Feel.BOMBER_SINE_AMPLITUDE_PX * Feel.BOMBER_SINE_RAD_PER_SEC * delta
		min_y = minf(min_y, position.y)
		max_y = maxf(max_y, position.y)
		fire_timer -= delta
		if fire_timer <= 0.0:
			fire_timer = Feel.BOMBER_FIRE_INTERVAL
			_fire_spread()

	func _fire_spread() -> void:
		var arms := Feel.BOMBER_SPREAD_COUNT
		for i in arms:
			var a := lerpf(-Feel.BOMBER_SPREAD_RAD, Feel.BOMBER_SPREAD_RAD, float(i) / float(arms - 1))
			_fire(Vector2(sin(a), cos(a)), Feel.BOMBER_BULLET_SPEED)  # spread points down
