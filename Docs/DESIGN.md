# Social Tsunami: Design & Technical Specification

## Game Overview

**Title:** Social Tsunami: Don't Wave Back

**Genre:** Physics-based party/arcade game with social anxiety humor.

**Core Mechanic:** Control a floppy ragdoll arm with the mouse to wave at NPCs approaching from the right. Some NPCs are waving at you, some are waving at someone behind you, and some are just swatting flies. Waving correctly earns points; waving incorrectly increases embarrassment.

---

## Technical Specification

### Engine & Scripting
- **Engine:** Godot 4.x (stable, open-source)
- **Scripting Language:** GDScript
- **Target Platform:** PC (Windows/Mac/Linux)
- **Resolution:** 1280 × 720 (16:9)
- **Target FPS:** 60

### Physics Model

#### Player
- **Movement:** Auto-walk at fixed speed (120 units/sec, configurable).
- **Arm:** 3-segment ragdoll (UpperArm → Forearm → Hand).
  - Each segment is a RigidBody2D with mass (0.5, 0.5, 0.3 respectively).
  - Segments connected by PinJoint2D (distance constraints).
  - Gravity acts on all segments (gravity_scale 1.0 for upper/forearm, 0.5 for hand).
- **Control:** Player drags the Hand via mouse (left-click hold).
  - Springy controller applies impulses to keep hand near mouse cursor.
  - Spring constant K=20, damping=6 (tunable).
  - Intentional "lag" for comedic effect.

#### NPCs
- **Movement:** Constant velocity from right to left (60 units/sec).
- **Despawn:** Removed when x < -100.
- **Behavior:**
  - 70% chance: Wave (real wave).
  - 30% chance: Fake-out (fixing hair, but same arm animation).
- **Wave Animation:** Arm rotates in sine wave for 1.5 seconds.
- **Signals:**
  - `on_wave_start(is_fake_out: bool)` — emitted when NPC begins waving.
  - `on_wave_end()` — emitted when wave ends.

---

## Game Rules & Scoring

### Scoring System

| Event | Points | Embarrassment | Social Credit |
|-------|--------|----------------|---------------|
| Correct Wave | +10 | – | +5 |
| False Positive (wave at fake-out) | – | +10 | -15 |
| Miss (no wave at real wave) | – | +10 | -15 |

### Metrics

1. **Score:** Cumulative points (only increases on correct waves).
2. **Embarrassment Meter:** 0–100 (visual progress bar, increases on errors).
3. **Social Credit:** 100–0 (decreases on errors; game ends at 0).

### Win/Lose Conditions
- **Lose:** Social Credit reaches 0 → Scene reloads.
- **Win:** (TBD, maybe survive 5 waves or reach 100 points).

---

## Wave Detection Contract

### What Counts as a "Wave"

**Input:** Player's left mouse button pressed & held while NPC is waving.

**Output:** Hand velocity exceeds `wave_detection_threshold` (default 0.3 units/frame).

**Details:**
- Minimum wave window: 0.5 seconds after NPC starts waving.
- Maximum wave window: 2.0 seconds (or until NPC finishes waving).
- Multiple hand movements count as one wave per NPC.
- Hand velocity is computed as `linear_velocity.length()` of the Hand RigidBody2D.

### Future Improvements
- Track hand position deltas and require "upward" motion to count as a wave.
- Add distance-based detection (wave must occur when NPC is near player).
- Use acceleration/jerk thresholds instead of velocity.

---

## Data Structures

### Player State
```gdscript
{
  position: Vector2,
  speed: float,
  hand_velocity: Vector2,
  spring_k: float,
  damping: float,
}
```

### NPC State
```gdscript
{
  position: Vector2,
  speed: float,
  is_waving: bool,
  is_fake_out: bool,
  waving_time: float,
}
```

### Game State
```gdscript
{
  score: int,
  embarrassment: float,
  social_credit: float,
  current_wave_npc: Node2D | null,
  player_waved_this_window: bool,
}
```

---

## Scene Hierarchy

```
Main (Node2D)
├── Background (Polygon2D)
├── NPCSpawner (Node2D) → spawns NPC instances
├── Player (Node2D) → player.gd
│   ├── Body (Polygon2D)
│   ├── Camera2D
│   ├── Arm (Node2D)
│   │   ├── UpperArm (RigidBody2D)
│   │   │   ├── CollisionShape2D
│   │   │   └── Visual (Polygon2D)
│   │   ├── Forearm (RigidBody2D)
│   │   │   ├── CollisionShape2D
│   │   │   └── Visual (Polygon2D)
│   │   ├── Hand (RigidBody2D)
│   │   │   ├── CollisionShape2D
│   │   │   └── Visual (Polygon2D)
│   │   ├── UpperArmJoint (PinJoint2D)
│   │   ├── ForearmJoint (PinJoint2D)
│   │   └── HandJoint (PinJoint2D)
│   ├── DebugLabel (Label)
│   └── GameManager (Node) → game_manager.gd
│       └── WaveDetector (Node) → wave_detector.gd
└── [NPC instances spawned at runtime]
    ├── Body (Polygon2D)
    ├── WaveArea (Area2D)
    ├── WaveTimer (Timer)
    └── Label (Label)
```

---

## Script Module Overview

### player.gd
- **Responsibilities:** Auto-walk, springy mouse-to-hand control.
- **Exports:** `speed`, `spring_k`, `damping`.
- **Input:** Left mouse button (drag).
- **Updates:** Player position every frame; applies impulses to Hand every physics frame.

### npc.gd
- **Responsibilities:** NPC behavior (movement, waving, fake-outs).
- **Exports:** `speed`, `wave_duration`.
- **Signals:** `on_wave_start(is_fake_out)`, `on_wave_end()`.
- **Updates:** Walks left; emits signals on wave start/end.

### npc_spawner.gd
- **Responsibilities:** Spawn NPCs at intervals.
- **Exports:** `spawn_interval`, `npcs_per_wave`.
- **Updates:** Creates new NPC instances every `spawn_interval` seconds.

### wave_detector.gd
- **Responsibilities:** Listen to NPC signals, check player wave validity.
- **Signals:** `wave_detected(is_correct, npc)`.
- **Connections:** Wires up `npc.on_wave_start` → `_on_npc_wave_start`, etc.
- **Logic:** Checks hand velocity during wave window; compares against `wave_detection_threshold`.

### game_manager.gd
- **Responsibilities:** Main game loop, score/meter updates, game end condition.
- **Exports:** `start_embarrassment`, `start_social_credit`.
- **Listens To:** `wave_detector.wave_detected`.
- **Updates:** Modifies `score`, `embarrassment`, `social_credit` based on wave events.

### arm.gd
- **Responsibilities:** Arm utilities (placeholder for future joint helpers).
- **Status:** Not yet implemented; reserved for complex arm rig logic.

---

## Input Map

| Input | Action |
|-------|--------|
| Left Mouse Button (Hold) | Drag hand to position |
| ESC | Pause (TBD) |
| R | Restart (TBD) |

---

## UI Layout (Planned)

```
[Social Credit: ████████░░ 80/100]  [Embarrassment: ██░░░░░░░░ 20/100]
[Score: 50]
```

Placed in top-left and top-center (CanvasLayer, always on top).

---

## Audio Design (Week 3)

| Sound | Trigger | Duration |
|-------|---------|----------|
| Swoosh (rising pitch) | Correct wave | 0.3s |
| Awkward cough | Embarrassment event | 0.5s |
| Ding | Correct wave bonus | 0.2s |
| Background ambience | Loop throughout | – |

---

## Art Style (Week 4)

- **Visual Theme:** Vaporwave (pastel pink/purple, 80s synth aesthetic).
- **Character Design:** Cartoony, flat (2D sprites in a side-scroller).
- **Background:** Scrolling parallax with neon signs, palm trees, etc.
- **NPC Design:** Simple stick figures or blobs, colored to distinguish states.

---

## Performance Targets

- **Frame Rate:** 60 FPS maintained on target hardware.
- **Memory:** <100 MB at runtime (no large asset packs yet).
- **Draw Calls:** <20 active (optimized for low-power devices in future).
- **Physics Update:** Godot's default physics tick (60 Hz).

---

## Known Issues & Limitations

1. **PinJoint2D stability:** Can deform or explode at very low FPS. Mitigation: enforce 60 FPS minimum.
2. **Wave detection false positives:** Currently only checks velocity; no directional constraint. Future: add hand position delta + upward bias.
3. **No serialization:** Game state not saved. Scope for future.
4. **No difficulty scaling:** All NPCs spawn at same rate and same wave probability. Future: add waves with escalating difficulty.

---

## Testing & Validation

### Unit Test Ideas (Week 4)
- NPC signal emission: verify `on_wave_start` fires correctly.
- Wave detection: mock hand velocity and verify threshold works.
- Score update: verify embarrassment/social credit changes correctly.

### Manual Testing Checklist
- [ ] Player walks smoothly across screen.
- [ ] Hand follows mouse with springy feel (no snapping, no lag >200ms).
- [ ] NPCs spawn every 2 seconds and walk left.
- [ ] NPCs emit signals at correct times.
- [ ] Correct waves increment score and social credit.
- [ ] Wrong waves increment embarrassment and decrement social credit.
- [ ] Game reloads when social credit reaches 0.

---

## Future Expansions

1. **Multiplayer:** Shared screen, multiple arms competing for waves.
2. **Custom Waves:** Editor tool to design NPC behaviors.
3. **Accessibility:** One-handed mode, colorblind modes, text-to-speech.
4. **Mobile Port:** Touch controls, accelerometer-based waving.
5. **Leaderboard:** Score tracking and sharing.

---

## Version History

- **v0.1 (Nov 2025):** Weeks 1–2 prototype (arm physics + NPC spawning).
- **v0.2 (Dec 2025):** Week 3 (UI, audio, meters).
- **v0.3 (Dec 2025):** Week 4 (vaporwave art, polish).

---

*End of Design Document.*
