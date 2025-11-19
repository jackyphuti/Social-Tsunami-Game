# 📋 Documentation Index

Welcome to **Social Tsunami: Don't Wave Back**! This folder contains a complete Godot 4.x prototype with comprehensive documentation.

## 📖 Docs at a Glance

| Document | Purpose | Read This If... |
|----------|---------|-----------------|
| **QUICKSTART.md** | 5-minute setup & play guide | You want to run the game immediately |
| **README.md** | Full project documentation | You want to understand everything |
| **DESIGN.md** | Technical specification & architecture | You're extending/modifying the code |
| **PROJECT_VALIDATION.md** | Build status & checklist | You want proof it works |
| **INDEX.md** (this file) | Navigation guide | You're lost 😄 |

## 🎮 Quick Links

### To Get Started
1. Read **QUICKSTART.md** (2 min)
2. Follow the setup steps
3. Run the game in Godot

### To Understand the Code
1. Read **DESIGN.md** (10 min) — architecture overview
2. Read **scripts/player.gd** — main player logic
3. Read **scripts/npc.gd** — NPC waving logic
4. Read **scripts/game_manager.gd** — scoring & game loop

### To Extend/Modify
1. Read **DESIGN.md** — understand the architecture
2. Look at the "Tuning Parameters" section in **README.md**
3. Modify `@export` variables in the Godot editor
4. Or edit the GDScript files directly

### To Test Everything Works
1. Open **project.godot** in Godot 4.x
2. Open **scenes/Main.tscn**
3. Press **F5** to play
4. See **PROJECT_VALIDATION.md** for expected behavior

## 🗂️ Project Structure

```
hack_Game/
├── INDEX.md                    ← You are here
├── README.md                   ← Full docs (start here if overwhelmed)
├── QUICKSTART.md               ← 5-min setup guide (start here if in a hurry)
├── DESIGN.md                   ← Technical spec (for developers)
├── PROJECT_VALIDATION.md       ← Build validation (for QA)
├── project.godot               ← Godot project manifest
│
├── scenes/
│   ├── Main.tscn               ← Root scene (OPEN THIS TO PLAY)
│   ├── Player.tscn             ← Player + ragdoll arm
│   └── NPC.tscn                ← NPC template
│
└── scripts/
    ├── player.gd               ← Player movement & arm control
    ├── npc.gd                  ← NPC behavior & signals
    ├── npc_spawner.gd          ← Spawn NPCs at intervals
    ├── wave_detector.gd        ← Detect player waves
    ├── game_manager.gd         ← Game loop & scoring
    ├── mouse_drag.gd           ← (Deprecated reference)
    └── arm.gd                  ← (Arm utilities placeholder)
```

## 🚀 Quick Start (TL;DR)

```bash
# 1. Install Godot 4.x from https://godotengine.org/
# 2. Open this folder as a project in Godot
# 3. Open scenes/Main.tscn
# 4. Press F5 to play
```

**How to play:**
- **Left-click and drag** your mouse to move the arm
- **Move quickly** to wave when NPCs approach
- **Correct wave** = +10 points
- **Wrong wave** = -15 social credit
- **Game over** when social credit reaches 0

## 📊 What's Implemented

| Week | Feature | Status |
|------|---------|--------|
| 1 | Player arm physics (3-segment ragdoll) | ✅ Done |
| 1 | Springy mouse control | ✅ Done |
| 1 | Auto-walk player | ✅ Done |
| 2 | NPC spawning | ✅ Done |
| 2 | Wave detection & fake-outs | ✅ Done |
| 2 | Scoring system | ✅ Done |
| 3 | UI meters (coming soon) | 🔜 Next |
| 3 | Sound effects (coming soon) | 🔜 Next |
| 4 | Vaporwave art (coming soon) | 🔜 Next |
| 4 | Polish & menus (coming soon) | 🔜 Next |

## 🎯 For Different Roles

### If You're a **Player**
1. Read **QUICKSTART.md**
2. Run the game
3. Move mouse left-click to wave
4. Try to beat the score!

### If You're a **Designer**
1. Read **DESIGN.md** for the game rules
2. Open **scenes/Main.tscn** in Godot
3. Adjust parameters in **scripts/npc_spawner.gd** (spawn rate, difficulty)
4. Adjust parameters in **scripts/game_manager.gd** (scoring, social credit)

### If You're a **Developer**
1. Read **DESIGN.md** for architecture
2. Familiarize yourself with **scripts/player.gd**, **npc.gd**, **game_manager.gd**
3. See **Tuning Parameters** in **README.md** for quick tweaks
4. For bigger changes, refer to code comments and **DESIGN.md**

### If You're **QA/Testing**
1. Read **PROJECT_VALIDATION.md** for test checklist
2. Run the game using **QUICKSTART.md**
3. Verify all features work as documented
4. Report any deviations

## 🔧 Tuning the Game

Most tweaks can be done without touching code:

1. **Open scenes/Main.tscn** in Godot
2. **In the Scene Tree** (left panel), expand **NPCSpawner**
3. **In the Inspector** (right panel), change:
   - `spawn_interval`: How often NPCs appear (default 2.0 sec)
   - `npcs_per_wave`: (placeholder, use `spawn_interval` instead)

For deeper tuning, edit these scripts:

| Parameter | File | Line | Effect |
|-----------|------|------|--------|
| Player speed | `scripts/player.gd` | Line 2 | How fast player walks |
| Arm spring feel | `scripts/player.gd` | Lines 3–4 | Snappiness of hand control |
| NPC spawn rate | `scripts/npc_spawner.gd` | Line 6 | How often NPCs appear |
| Wave window | `scripts/npc.gd` | Line 14 | How long NPC waves for |
| Scoring | `scripts/game_manager.gd` | Lines 28–40 | Points/embarrassment/credit |

## ❓ FAQ

**Q: The game won't open in Godot.**
A: Make sure you have Godot 4.x installed. The project file is `project.godot`.

**Q: My hand doesn't follow the mouse.**
A: Left-click and hold, then move. The hand is physical (heavy), so it has inertia.

**Q: NPCs don't spawn.**
A: Check that `NPCSpawner` script is running. In the Scene Tree, verify `NPCSpawner` node has the script attached.

**Q: How do I know if I waved correctly?**
A: Check the console output (in Godot's Output panel). It prints "Correct wave! +10 points" or "Wrong wave! +10 embarrassment".

**Q: How do I restart the game?**
A: When social credit reaches 0, the scene reloads automatically.

**Q: Can I change the difficulty?**
A: Yes! Edit `spawn_interval` in `NPCSpawner` (lower = harder). Edit `wave_detection_threshold` in `WaveDetector` (lower = easier).

## 📞 Support

**Need help?**
- Read the relevant doc from the table at the top of this file
- Check code comments in the script files
- Refer to **DESIGN.md** for architecture questions

**Want to contribute?**
- Fork or clone this repo
- Make changes in a branch
- Test using the steps in **QUICKSTART.md**
- Submit a PR with clear description

## 🎬 Next Steps

### To Continue Development
1. Start **Week 3**: Read the "Next Steps (Week 3)" section in **README.md**
2. Add UI meters and sound effects
3. Improve wave detection
4. Test and iterate

### To Use as a Base for Your Own Game
1. Duplicate this project
2. Rename it
3. Modify **DESIGN.md** for your game rules
4. Replace placeholder art with your own
5. Extend the scripts as needed

---

**Created:** November 19, 2025
**Game:** Social Tsunami: Don't Wave Back
**Engine:** Godot 4.x
**Language:** GDScript

Enjoy! 👋
