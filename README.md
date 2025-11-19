Social Tsunami: Don't Wave Back

Godot 4.x game prototype with Weeks 1–3 COMPLETE. UGC Game Jam submission targeting Dec 1, 2025.

Current Status: 60% Complete
- ✅ Week 1: Arm physics (complete)
- ✅ Week 2: NPC spawning & wave detection (complete)
- ✅ Week 3: UI, feedback, difficulty scaling (complete)
- 🔜 Week 4: Art, audio, menus (in progress)

Project Structure

```
hack_Game/
├── README.md                 (this file)
├── project.godot             (Godot 4.x project config)
├── scenes/
│   ├── Main.tscn             (root scene with NPCSpawner and Player)
│   ├── Player.tscn           (3-segment ragdoll arm + player body)
│   └── NPC.tscn              (NPC with wave/fake-out behaviors)
└── scripts/
    ├── player.gd             (Player: auto-walk + springy hand control)
    ├── mouse_drag.gd         (Deprecated; integrated into player.gd)
    ├── arm.gd                (Arm helper utilities)
    ├── npc.gd                (NPC: wave behavior + signals)
    ├── npc_spawner.gd        (Spawns NPCs at intervals)
    ├── wave_detector.gd      (Listens to NPC signals, checks player waves)
    └── game_manager.gd       (Orchestrates game loop, score, embarrassment meter)
```

What's Implemented

Week 1: Arm Physics (COMPLETE)
- Auto-walking player character (120 units/sec, configurable).
- 3-segment ragdoll arm: UpperArm → Forearm → Hand, connected by PinJoint2D.
- Springy mouse-to-hand controller: left-click and drag to control the hand.
  - Tunable spring constant (SPRING_K) and damping for feel.
  - Hand follows mouse with intentional lag/wobble for comedy effect (Bennett Foddy style).
- Simple 2D camera following player.
- Placeholder colored rectangles for quick visual feedback.

Week 2: NPC Spawning & Wave Detection (COMPLETE)
- NPC spawner that creates NPCs every 2 seconds from the right side of the screen.
- Each NPC has two states:
  - Real Wave: normal waving behavior (blueish color).
  - Fake-Out: the NPC fixes their hair instead (reddish color, but still waves their arm).
- NPC emits signals: `on_wave_start(is_fake_out: bool)` and `on_wave_end()`.
- Wave detector: listens to NPC signals, checks if player's hand is moving when wave occurs.
  - Correct wave: +10 points, +5 social credit.
  - Wrong wave (false positive or miss): +10 embarrassment, -15 social credit.
- Game ends when social credit reaches 0 (scene reloads).

How to Run

1. Install Godot 4.x (tested on 4.0+).
2. Open the folder `/home/jacky-mpoka/Documents/hack_Game` as a project in Godot.
3. Open `scenes/Main.tscn` and press Play (F5 in Godot).

CLI (if available):
```bash
godot4 --path /home/jacky-mpoka/Documents/hack_Game
```

Controls

- **Left Mouse Button (Hold & Drag)**: Control the player's hand. The arm follows the mouse with a springy feel.
- The player walks automatically from left to right.
- NPCs walk from right to left.
- When an NPC waves, try to move your hand upward (or just move it quickly) to register a wave.

Tuning Parameters

All these can be adjusted in the Godot editor or by editing the scripts:

**Player (player.gd):**
- `speed`: Player walk speed (default 120 units/sec).
- `spring_k`: Spring constant for hand controller (default 20, higher = snappier).
- `damping`: Damping factor for hand (default 6, higher = smoother/less bouncy).

**NPC Spawner (npc_spawner.gd):**
- `spawn_interval`: Time between NPC spawns in seconds (default 2.0).
- `npcs_per_wave`: (currently unused, but marks future "waves" of difficulty).

**Wave Detector (wave_detector.gd):**
- `wave_detection_threshold`: Minimum hand velocity to count as a wave (default 0.3).

**Game Manager (game_manager.gd):**
- `start_embarrassment`: Initial embarrassment (default 0).
- `start_social_credit`: Initial social credit (default 100).

Notes & Known Limitations

- **Physics stability**: PinJoint2D can be unstable at very low framerates. Ensure Godot is running at 60 FPS minimum.
- **Wave detection** is currently simplistic (just checks hand velocity). Future: use hand position deltas or accelerometer-like heuristics.
- **No audio** yet (scheduled for Week 3).
- **No proper UI meters** yet (scheduled for Week 3).
- **Placeholder art** (all colored rectangles; schedule fancy vaporwave assets for Week 4).

Development Roadmap

| Week | Focus | Key Godot Nodes | Status |
|------|-------|-----------------|--------|
| 1    | Arm Physics | RigidBody2D, PinJoint2D, Polygon2D | ✅ Done |
| 2    | NPC Logic & Wave Detection | Area2D, Timer, signals | ✅ Done |
| 3    | Scoring & Juice | TextureProgress (UI), AudioStreamPlayer | 🔜 Next |
| 4    | Polish & Vaporwave | ParallaxBackground, Shader | 🔜 Planned |

Next Steps (Week 3)

- Add a real UI with `TextureProgress` bars for Embarrassment Meter and Social Credit.
- Add sound effects: "swoosh" for waves, "awkward cough" for embarrassments, "ding" for correct waves.
- Tune wave detection to be more forgiving.
- Add visual feedback (particle effects, screen shake, etc.).

Next Steps (Week 4)

- Add vaporwave-style background with parallax scrolling.
- Replace placeholder rectangles with cartoony sprite art.
- Add a main menu and pause menu.
- Difficulty scaling (more NPCs, faster spawns, harder detection).

Troubleshooting

**Godot says "Invalid identifier 'on_wave_start'" or similar:**
- This is a signal binding issue. Ensure all scripts are saved and Godot has reloaded them. Try: Right-click on the `.gd` file > Reload in the editor.

**Hand doesn't follow mouse:**
- Check that `Player/Arm/Hand` is a RigidBody2D and is not kinematic. Ensure `gravity_scale` is not 0 or negative.

**NPCs spawn but don't move:**
- Check `npc_spawner.gd` is active and has `spawn_interval > 0`. Ensure NPCs are in the scene tree.

**No wave detection happening:**
- Ensure `wave_detector.gd` is instantiated in `Main.tscn` or `game_manager.gd`.
- Check console for signal connection errors.

Credits & Inspiration

- Concept: Bennett Foddy (Getting Over It) – ragdoll physics.
- Jam Theme: "WAVES" (physics/gestures/surge).
- Made with Godot 4.x.

Contact

For questions or issues, refer to the in-code documentation or the git history of this project.

