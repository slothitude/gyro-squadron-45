class_name Feel
## GYRO SQUADRON '45 — every control/weapon/spawn number lives here.
## Spec law "constants_not_magic": no tuned number anywhere else in the project.

# ---------------------------------------------------------------- tilt input --
const DEAD_ZONE := 0.06               # spec: dead_zone 0.06 (normalized tilt)
const CURVE_EXPONENT := 2.0           # spec: quadratic response, precise center
const SENSITIVITY := 1.6              # spec: sensitivity 1.6
const TILT_BLEND_GYRO := 0.15         # touch of gyroscope for responsiveness
const GRAVITY_NORM := 9.81            # m/s^2; gravity.x / this -> -1..1 tilt
const GYRO_NORM_SCALE := 2.0          # rad/s of gyro.x that counts as "full"
const OUTPUT_MAX := 1.0               # shaped output saturates here

# ------------------------------------------------------------- touch fallback --
const TOUCH_DRAG_RANGE_PX := 160.0    # finger travel equal to full deflection

# --------------------------------------------------------------------- plane --
const PLANE_MAX_SPEED := 480.0        # px/s at full deflection
const CLAMP_MARGIN := 24.0            # px kept clear of the screen edges
const BANK_MAX_TILT := 0.35           # rad of visual bank at full deflection
const BANK_LERP_SPEED := 12.0         # how fast the bank rotation settles
const BANK_SPRITE_THRESHOLD := 0.30   # shaped output where bank sprite swaps in
const PLANE_SPRITE_SCALE := 0.16      # 493px source art -> ~79px on a 540 screen
const PLANE_START_FRACTION := 0.66    # bottom-third spawn line

# -------------------------------------------------- scroll (milestone 1 only) --
const SCROLL_SPEED_TEST := 60.0       # px/s test auto-scroll for the sea
const SEA_BAND_PX := 48.0             # fallback code-drawn sea band height

# --------------------------------------------------------------------- debug --
const DEBUG_SAMPLE_EVERY_N_FRAMES := 10

# --------------------------------------------------------- weapons (Act 1) --
# Values from spec.weapons — spec law "constants_not_magic": this is the only
# tuned-number file in the project.
const FIRE_RATE := 8.0                # shots/s
const BULLET_SPEED := 700.0           # px/s
const WEAPON_TIERS := 4
const WEAPON_TIER_MIN := 1
const SUPER_SHOT_CHARGE_KILLS := 12   # kills to fill the charge meter
const SUPER_SHOT_DURATION := 1.6      # s of beam
const SUPER_SUSPENDS_NORMAL_FIRE := true
const BOMB_START_COUNT := 2

# Weapon tier volley shapes (spec: 1 single, 2 twin, 3 twin+angled pair, 4 triple)
const TIER_TWIN_OFFSET_PX := 16.0     # x offset of each twin barrel
const TIER_TRIPLE_OFFSET_PX := 28.0   # x offset of outer triple-stream barrels
const TIER_ANGLED_RAD := 0.22         # ~12.6 deg off vertical for the angled pair
const TIER_ANGLED_OFFSET_PX := 8.0    # x offset of the angled pair muzzles
const MUZZLE_OFFSET := Vector2(0.0, -30.0)  # plane nose relative to position

# Bullets / pooling
const PLAYER_BULLET_DAMAGE := 1
const PLAYER_BULLET_RADIUS := 8.0
const PLAYER_BULLET_SCALE := 0.05     # 156x810 art -> ~8x40 px
const ENEMY_BULLET_DAMAGE := 1
const ENEMY_BULLET_RADIUS := 8.0
const ENEMY_BULLET_SCALE := 0.045     # 290x701 art -> ~13x32 px
const BULLET_POOL_PLAYER_CAP := 96
const BULLET_POOL_ENEMY_CAP := 96
const BULLET_OFFSCREEN_MARGIN_PX := 48.0

# Super Shot beam
const SUPER_BEAM_WIDTH_PX := 120.0    # huge hitbox: full column this wide
const SUPER_BEAM_DPS := 30.0          # damage/s to everything under the beam
const SUPER_BEAM_COLOR := Color(1.0, 0.85, 0.25, 0.55)

# Bomb
const BOMB_DAMAGE := 8                # heavy damage to EVERY enemy incl. boss
const BOMB_FLASH_SEC := 0.4
const BOMB_FLASH_COLOR := Color(1.0, 1.0, 0.9, 0.35)

# ----------------------------------------------------------- player (Act 1) --
const PLAYER_LIVES := 3               # spec structure.lives
const PLAYER_HIT_IFRAME_SEC := 1.5    # brief invulnerability after a hit
const PLAYER_HIT_TIER_LOSS := 1       # spec hit_penalty: weapon tier -1
const PLAYER_RADIUS := 22.0           # hit circle

# ------------------------------------------------------------ enemies (Act 1) --
const FIGHTER_HP := 1                 # spec act1 fighter_straight
const FIGHTER_SPEED := 230.0          # dive speed, px/s downward
const FIGHTER_RADIUS := 26.0
const FIGHTER_SCORE := 50             # spec scoring.per_kill
const FIGHTER_FIRST_FIRE_DELAY := 0.9
const FIGHTER_FIRE_INTERVAL := 1.9
const FIGHTER_FIRE_STATE_SEC := 0.12  # brief FIRE beat in the state machine
const FIGHTER_SPRITE_SCALE := 0.10    # 743x583 art -> ~74x58 px
const ENEMY_BULLET_SPEED := 260.0     # aimed shot speed

const BOMBER_HP := 4                  # spec act1 bomber_slow
const BOMBER_SPEED := 72.0            # slow drift across, px/s
const BOMBER_RADIUS := 40.0
const BOMBER_SCORE := 150
const BOMBER_SINE_AMPLITUDE_PX := 36.0
const BOMBER_SINE_RAD_PER_SEC := 1.7
const BOMBER_FIRST_FIRE_DELAY := 1.2
const BOMBER_FIRE_INTERVAL := 2.3
const BOMBER_SPREAD_COUNT := 3        # 3-shot spread downward
const BOMBER_SPREAD_RAD := 0.30       # per-arm angle off straight down
const BOMBER_BULLET_SPEED := 210.0
const BOMBER_SPRITE_SCALE := 0.11     # 782x765 art -> ~86x84 px
const BOMBER_LANE_MIN_Y := 150.0      # drift lanes near the top half
const BOMBER_LANE_MAX_Y := 340.0

# ---------------------------------------------------------------- scoring --
const SCORE_PER_KILL := 50            # spec scoring.per_kill (base)
const NO_DAMAGE_BONUS := 5000         # spec scoring.no_damage_bonus

# ---------------------------------------------------------------- boss1 --
const BOSS1_HP := 40                  # spec: bomber_fortress hp 40
const BOSS1_PHASE2_HP := 20           # phase 2 at half hp
const BOSS1_ENTER_SPEED := 90.0       # px/s descent onto the stage
const BOSS1_ENTER_Y := 170.0
const BOSS1_DRIFT_SPEED_RAD := 0.55   # rad/s of the sine drift phase
const BOSS1_DRIFT_AMPLITUDE_PX := 120.0
const BOSS1_RADIUS := 84.0
const BOSS1_SCORE := 3000
const BOSS1_SWEEP_COUNT := 5          # 5-way spread sweeps
const BOSS1_SWEEP_ARC_RAD := 1.1      # total arc of the 5-way spread
const BOSS1_SWEEP_INTERVAL := 1.6     # phase 1 sweep cadence
const BOSS1_SWEEP_INTERVAL_P2 := 1.0  # phase 2: faster sweep
const BOSS1_SWEEP_WOBBLE_RAD := 0.45  # sweep aim wobbles +- this, volley to volley
const BOSS1_SWEEP_WOBBLE_STEP_RAD := 0.22
const BOSS1_BURST_COUNT := 3          # phase 2 aimed burst: 3 quick shots
const BOSS1_BURST_GAP_SEC := 0.16     # gap between burst shots
const BOSS1_BURST_PERIOD := 2.2       # seconds between aimed bursts
const BOSS1_SWEEP_BULLET_SPEED := 250.0
const BOSS1_AIM_BULLET_SPEED := 330.0
const BOSS1_SPRITE_SCALE := 0.22      # 796x804 art -> ~175x177 px

# ---------------------------------------------------------------- stage (Act 1) --
const STAGE_LEN_SEC := 55.0           # spec structure.stage_len_target_sec
const STAGE_FIGHTER_WAVE_SEC := 2.2   # fighter pair every ~2.2 s
const STAGE_FIGHTERS_PER_WAVE := 2    # pairs
const STAGE_BOMBER_WAVE_SEC := 7.0    # bomber every ~7 s
const STAGE_FIGHTER_FIRST_DELAY := 0.6
const STAGE_BOMBER_FIRST_DELAY := 4.0
const STAGE_ESCALATE_EVERY_SEC := 15.0
const STAGE_ESCALATE_SCALE := 0.85    # spawn intervals shrink per escalation
const STAGE_ESCALATE_MIN_SCALE := 0.55
const STAGE_RNG_SEED := 1945          # deterministic spawn order for tests
const STAGE_SPAWN_Y := -60.0
const STAGE_FIGHTER_SPAWN_INSET_PX := 40.0  # keep dive columns off the walls
const STAGE_CLEAR_DELAY_SEC := 1.4    # explosion beat before the tally
const STAGE_BOSS_SPAWN_Y := -140.0

# -------------------------------------------------------------- pickups v1 --
const PICKUP_DROP_CHANCE := 0.22      # downed enemies occasionally drop P
const PICKUP_FALL_SPEED := 130.0
const PICKUP_RADIUS := 20.0
const PICKUP_TIER_GAIN := 1           # v1-simple: each P = +1 tier (spec 3/tier arrives in m3)
const PICKUP_COLOR := Color(0.95, 0.82, 0.25)
const PICKUP_OUTLINE_COLOR := Color(0.1, 0.08, 0.05)

# --------------------------------------------------------------- fx / hud --
const EXPLOSION_SMALL_RADIUS := 46.0
const EXPLOSION_BIG_RADIUS := 150.0   # boss death
const EXPLOSION_DURATION := 0.55
const HUD_MARGIN_PX := 10.0
const HUD_FONT_SIZE := 30
const HUD_OUTLINE_SIZE := 10
const HUD_COLOR := Color(1.0, 0.96, 0.85)
const HUD_OUTLINE_COLOR := Color(0.05, 0.08, 0.12)
const HUD_TIER_PIP_FULL := "P"
const HUD_TIER_PIP_EMPTY := "-"
const CHARGE_BAR_SIZE := Vector2(170.0, 16.0)
const CHARGE_FULL_COLOR := Color(1.0, 0.82, 0.2)
const CHARGE_EMPTY_COLOR := Color(0.18, 0.22, 0.28)
