class_name PlayerPlane
extends CharacterBody2D
## Milestone 1 player ship: steering = TiltSource output * Feel.PLANE_MAX_SPEED,
## clamped to the screen minus Feel.CLAMP_MARGIN, banking sprite + tilt.
## Milestone 2: hosts the auto-fire Weapon (node-hosted, RefCounted) — the
## weapon fires every step once a BulletPool is injected by the Stage.

const TEX_LEVEL := "res://assets/generated/player_p51.png"
const TEX_BANK_LEFT := "res://assets/generated/player_bank_left.png"

var tilt_input := 0.0
var weapon: Weapon = Weapon.new()

var _sprite: Sprite2D
var _tex_level: Texture2D
var _tex_bank: Texture2D
var _bank_state := 0  # -1 = bank left, 0 = level, 1 = bank right


func _ready() -> void:
	_sprite = Sprite2D.new()
	_sprite.scale = Vector2.ONE * Feel.PLANE_SPRITE_SCALE
	add_child(_sprite)
	if ResourceLoader.exists(TEX_LEVEL):
		_tex_level = load(TEX_LEVEL)
	if ResourceLoader.exists(TEX_BANK_LEFT):
		_tex_bank = load(TEX_BANK_LEFT)
	_sprite.texture = _tex_level


## Drive one frame of movement from a shaped TiltSource output.
## Deterministic (explicit integration, no collision dependency) so the
## synthetic battery can step it without physics ticking.
func step(output: float, delta: float) -> void:
	tilt_input = output
	velocity.x = output * Feel.PLANE_MAX_SPEED
	position.x += velocity.x * delta
	_clamp_to_bounds()
	_apply_bank(output, delta)
	weapon.step(delta, position + Feel.MUZZLE_OFFSET)  # auto-fire always on


func _physics_process(delta: float) -> void:
	step(tilt_input, delta)


func _clamp_to_bounds() -> void:
	var width := get_viewport_rect().size.x
	position.x = clampf(position.x, Feel.CLAMP_MARGIN, width - Feel.CLAMP_MARGIN)


func _apply_bank(output: float, delta: float) -> void:
	if _sprite == null:
		return
	var target := clampf(output, -1.0, 1.0) * Feel.BANK_MAX_TILT
	_sprite.rotation = lerp_angle(_sprite.rotation, target, clampf(Feel.BANK_LERP_SPEED * delta, 0.0, 1.0))
	var wanted := 0
	if output < -Feel.BANK_SPRITE_THRESHOLD:
		wanted = -1
	elif output > Feel.BANK_SPRITE_THRESHOLD:
		wanted = 1
	if wanted != _bank_state:
		_bank_state = wanted
		if _tex_bank != null and wanted != 0:
			_sprite.texture = _tex_bank
			_sprite.flip_h = wanted > 0  # bank_right = mirrored bank_left
		else:
			_sprite.texture = _tex_level
			_sprite.flip_h = false
