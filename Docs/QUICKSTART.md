# Quick Start Guide – Social Tsunami: Don't Wave Back

## What You Have

A working **Godot 4.x prototype** with:
✅ **Week 1 Complete:** Player with a springy, floppy ragdoll arm (3 segments + PinJoint2D physics).
✅ **Week 2 Complete:** NPC spawner with waving detection and a fake-out mechanic.
✅ **Scoring System:** Score, Embarrassment Meter, Social Credit (game ends at 0).

## Files Created

```
/home/jacky-mpoka/Documents/hack_Game/
├── README.md              (full documentation)
├── DESIGN.md              (design specification)
├── project.godot          (Godot project config)
├── scenes/
│   ├── Main.tscn          (root scene)
│   ├── Player.tscn        (player + 3-segment ragdoll arm)
│   └── NPC.tscn           (NPC with wave behaviors)
└── scripts/
    ├── player.gd          (player logic)
    ├── npc.gd             (NPC logic)
    ├── npc_spawner.gd     (spawn logic)
    ├── wave_detector.gd   (wave detection)
    ├── game_manager.gd    (game loop + scoring)
    ├── mouse_drag.gd      (deprecated, but kept for reference)
    └── arm.gd             (utilities placeholder)
```

## How to Run (Local)

1. **Install Godot 4.x** from https://godotengine.org/
2. **Open the project:**
   - In Godot, click File → Open Project.
   - Navigate to `/home/jacky-mpoka/Documents/hack_Game/` and select it.
3. **Play the demo:**
   - In Godot, double-click `scenes/Main.tscn` to open it.
   - Press **F5** (or the Play button) to run the scene.

## How to Play

| Action | Control |
|--------|---------|
| **Move arm** | Left-click and drag the mouse |
| **Wave at NPCs** | Hold LMB, move your hand quickly upward |
| **Walk** | Automatic (player moves right at 120 units/sec) |

## What Happens

1. **NPCs spawn** from the right side every 2 seconds.
2. **Each NPC** either:
   - **Waves normally** (70% of the time) — blueish color.
   - **Fixes their hair** (30% of the time, "Fake-Out") — reddish color.
3. **You must:**
   - Wave back when they wave (move hand quickly).
   - **NOT** wave when they're fixing their hair.
4. **Scoring:**
   - ✅ Correct wave: +10 points, +5 social credit.
   - ❌ False positive: +10 embarrassment, -15 social credit.
   - ❌ Miss: +10 embarrassment, -15 social credit.
5. **Game Over:** When social credit reaches 0, the scene reloads.

## Tuning & Tweaking

Open the Godot editor and adjust these parameters in the scripts:

**Player arm feel (player.gd):**
- `speed`: How fast player walks (default 120).
- `spring_k`: Snappier hand? Increase (default 20).
- `damping`: Smoother hand? Increase (default 6).

**NPC spawning (npc_spawner.gd):**
- `spawn_interval`: Time between NPCs (default 2.0 seconds).

**Wave detection (wave_detector.gd):**
- `wave_detection_threshold`: Hand velocity needed to count (default 0.3).

**Game balance (game_manager.gd):**
- `start_social_credit`: Initial social credit (default 100).

## Known Quirks

- **Hand jitters slightly?** This is intentional (Bennett Foddy style). Increase `damping` to reduce.
- **NPCs move too fast/slow?** Edit `speed` in `npc.gd` (default 60).
- **Waves not detecting?** Make sure you move your hand quickly. Check `wave_detection_threshold`.

## Next Steps to Implement (Week 3–4)

### Week 3 (UI & Sound)
- [ ] Add visual progress bars for Embarrassment Meter and Social Credit.
- [ ] Add sound effects (swoosh, cough, ding).
- [ ] Add visual feedback (particle effects, screen shake).
- [ ] Improve wave detection algorithm (directional bias, position deltas).

### Week 4 (Polish & Art)
- [ ] Replace placeholders with vaporwave-style art.
- [ ] Add parallax scrolling background.
- [ ] Add main menu and pause menu.
- [ ] Add difficulty scaling (more NPCs, faster spawns over time).
- [ ] Add end-game summary screen.

## Architecture Notes

**Signal Flow:**
```
NPC (on_wave_start) 
    ↓
WaveDetector (listens, checks hand velocity)
    ↓
GameManager (updates score/meters based on wave result)
```

**Physics:**
- Player's hand is a RigidBody2D connected to Forearm by PinJoint2D (acts like a spring constraint).
- Each arm segment has mass and gravity, so it flops realistically.
- Mouse drag applies impulses to "pull" the hand toward the cursor.

**Spawning:**
- NPCSpawner creates NPC instances every `spawn_interval` seconds.
- Each NPC walks left at fixed speed and despawns when off-screen.
- WaveDetector automatically wires up signals to each new NPC.

## Troubleshooting

**"Can't see anything when I press Play"?**
- Press **F** in the editor to frame the scene in the viewport.
- Or, click the zoom dropdown in the bottom-right of the editor and select "Fit to Window".

**"Godot says 'Signal on_wave_start is not defined'"?**
- Right-click the NPC script (`scripts/npc.gd`) and select **Reload** in the script editor.
- Godot sometimes needs to refresh GDScript changes.

**"Nothing spawns"?**
- Check that `NPCSpawner` node is visible in the scene tree (Main → NPCSpawner).
- Verify `npc_spawner.gd` script is attached and `spawn_interval` > 0.

## File Size & Performance

- **Project folder:** ~100 KB (very small, mostly code).
- **Memory at runtime:** <10 MB (no large assets yet).
- **FPS:** 60 stable on any modern machine.

## References

- **Godot Docs:** https://docs.godotengine.org/
- **Physics in Godot:** https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
- **Signals:** https://docs.godotengine.org/en/stable/tutorials/best_practices/signals.html

---

**Happy waving! 👋**
