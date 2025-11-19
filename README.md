# Social Tsunami - Game Project

**A vaporwave-aesthetic social anxiety simulator about mastering the art of the wave.**

## Overview

Social Tsunami is a fast-paced arcade game built in Godot 4.5 where players control a springy ragdoll arm to respond to NPCs' waves at just the right moment. Misread the cues and watch your embarrassment grow while your social credit plummets!

### Game Concept
- **Objective:** Successfully identify and reciprocate genuine waves while avoiding fake-outs (hair flips)
- **Mechanics:** Spring-physics arm controlled by mouse; detect hand position during NPC waving windows
- **Difficulty:** Dynamic NPC spawn rate scaling with game duration
- **Tone:** Humorous social commentary with vaporwave aesthetics

**Status:** ✅ **100% COMPLETE** - Ready for submission (UGC Game Jam, Dec 1, 2025)

---

## Features

### Gameplay
✅ **Physics-based Arm Control**: 3-segment ragdoll arm (UpperArm → Forearm → Hand) with springy mouse tracking  
✅ **NPC Wave Detection**: Signal-based event system for real waves vs fake-outs  
✅ **Difficulty Scaling**: Spawn rates increase over time; difficulty meters for progression  
✅ **Dynamic Scoring**: Points for correct waves; penalties for errors  
✅ **Visual Feedback**: Screen shake on errors, UI pulse on success, pastel NPC colors  

### Presentation
✅ **Vaporwave Aesthetic**: Gradient background with horizon lines and pastel color palette  
✅ **Procedural Sprites**: Pastel-colored NPCs generated at runtime  
✅ **Sound System**: Audio events for waves, fails, warnings, and game over (placeholder WAV files)  
✅ **UI System**: Real-time progress bars for Embarrassment & Social Credit meters  

### Navigation
✅ **Main Menu**: Start/Quit buttons with clean UI  
✅ **Pause Menu**: ESC key toggle with Resume/Main Menu  
✅ **End Screen**: Final score display with Restart/Main Menu options  
✅ **Global State**: Autoload system for passing game stats between scenes  

---

## Project Structure

```
hack_Game/
├── scenes/
│   ├── Main.tscn                 # Gameplay scene (root)
│   ├── Player.tscn               # 3-segment arm with camera
│   ├── NPC.tscn                  # NPC template (spawned)
│   ├── MainMenu.tscn             # Title/menu screen
│   ├── PauseMenu.tscn            # Pause overlay
│   └── EndScreen.tscn            # Game-over stats screen
│
├── scripts/
│   ├── player.gd                 # Arm physics & mouse control
│   ├── npc.gd                    # NPC behavior, waving, fake-outs
│   ├── npc_spawner.gd            # NPC spawning with intervals
│   ├── wave_detector.gd          # Wave detection (velocity + upward motion)
│   ├── game_manager.gd           # Game loop, scoring, events
│   ├── ui_manager.gd             # Progress bars & labels (runtime-built)
│   ├── visual_feedback.gd        # Screen shake & UI effects
│   ├── difficulty_manager.gd     # Spawn rate scaling
│   ├── sound_manager.gd          # Audio playback via ResourceLoader
│   ├── vaporwave_background.gd   # Gradient background with parallax
│   ├── procedural_sprite_gen.gd  # Pastel sprite generation
│   ├── main_menu.gd              # Menu navigation
│   ├── pause_menu.gd             # Pause/resume logic
│   ├── end_screen.gd             # Final stats display
│   └── global.gd                 # Global singleton (autoload)
│
├── sounds/
│   ├── wave_success.wav
│   ├── wave_fail.wav
│   ├── fake_out.wav
│   ├── social_credit_low.wav
│   ├── game_over.wav
│   └── bg_music.wav
│
├── project.godot                 # Godot project file
├── README.md                     # This file
├── TUNING_GUIDE.md              # Parameter tuning documentation
└── Docs/                        # Additional documentation
```

---

## Controls

| Input | Action |
|-------|--------|
| **LMB (Hold & Drag)** | Pull arm toward mouse position |
| **ESC** | Pause/Resume game |
| **Mouse Move** | Target arm hand position |

---

## Game Mechanics

### Scoring System
- **Correct Wave**: +10 points, +5 social credit
- **Wrong Wave/Missed**: +10 embarrassment, -15 social credit
- **Low Credit Warning** (≤25): Audio alert plays
- **Game Over**: Social credit ≤ 0

### Difficulty Progression
- **Starting Spawn Interval**: 2.0 seconds (1 NPC every 2 seconds)
- **Minimum Spawn Interval**: 0.8 seconds (hardest difficulty)
- **Scale Rate**: 2% reduction per second
- **Time to Max Difficulty**: ~60 seconds

### NPC Types
- **Real Wave** (70%): NPC waves arm genuinely
- **Fake-Out/Hair Flip** (30%): Similar motion but doesn't count as valid wave

---

## Running the Game

### Requirements
- **Godot 4.5.stable** or later
- **GDScript** (no C# required)
- **Linux/Windows/macOS** (Godot-compatible platform)

### Startup
1. Open Godot 4.5+
2. Import the project folder: `/home/jacky-mpoka/Documents/hack_Game`
3. Run the project (F5 or Play button)
4. Main Menu will load first (entry scene: `res://scenes/MainMenu.tscn`)

### Play
1. Click **START** to begin gameplay
2. Click and drag the mouse to control the arm
3. Catch NPCs' waves at the right moment
4. Avoid fake-outs to maintain social credit
5. Press **ESC** to pause
6. Game ends when social credit reaches 0

---

## Parameter Tuning

All key gameplay parameters are exposed as **Export Variables** for easy tweaking without code changes:

### Quick-Tuning Locations
- **Player Arm Control**: `Main.tscn` → Select "Player" instance → Inspect export vars
- **NPC Behavior**: `NPC.tscn` → Select root node → Inspect export vars
- **Difficulty Scaling**: `Main.tscn` → Select "DifficultyManager" node → Inspect export vars
- **Scoring & Meters**: `Main.tscn` → Select "Main" node → Inspect export vars

**See `TUNING_GUIDE.md` for comprehensive parameter reference and recommended presets** (Easy/Normal/Hard/Arcade/Speedrun).

---

## Audio Implementation

### Audio Files
- **Format**: WAV (44.1kHz, mono, 16-bit) - placeholder files included
- **Location**: `res://sounds/`
- **System**: AudioStreamPlayer nodes created at runtime via `sound_manager.gd`

### Sound Events
- `play_wave_success()` - Correct wave detected
- `play_wave_fail()` - Wrong wave or missed
- `play_fake_out_detected()` - Fake-out caught early
- `play_social_credit_low()` - Credit falling below threshold
- `play_game_over()` - Game ends

### Replacing Placeholder Audio
1. Record/generate your own audio files (WAV format recommended)
2. Place them in `res://sounds/` with matching names
3. Godot will reload them automatically on project restart

---

## Architecture Highlights

### Signal-Based Event System
```
NPC.on_wave_start(is_fake_out) → WaveDetector → GameManager._on_wave_detected()
NPC.on_wave_end → Cleanup
```

### Physics-Based Arm Control
Spring-force impulse applied to hand RigidBody2D based on mouse position:
```
desired_velocity = (mouse_pos - hand_pos) * spring_strength
impulse = (desired_velocity - current_velocity) * hand_mass * delta
hand.apply_central_impulse(impulse)
```

### Difficulty Scaling Algorithm
Spawn interval decreases over time:
```
elapsed_time += delta
difficulty = elapsed_time * scale_rate
new_interval = max(min_interval, start_interval - difficulty)
```

### Wave Detection Logic
Hand must be in NPC's WaveArea AND moving upward:
```
if hand_in_wave_area and hand.linear_velocity.y < threshold:
    emit_signal("wave_detected", is_correct)
```

---

## Tested Features

✅ Game launches from Main Menu without errors  
✅ Gameplay scene loads with all systems active  
✅ NPCs spawn at configurable intervals  
✅ Wave detection triggers on hand contact + upward motion  
✅ Scoring updates correctly  
✅ UI progress bars and labels display properly  
✅ Pause menu toggles with ESC key  
✅ End screen shows final stats  
✅ Audio manager initializes and loads placeholder files  
✅ Difficulty scaling reduces spawn interval over time  
✅ Visual feedback (screen shake, UI pulse) activates on events  
✅ All menu transitions work smoothly  
✅ Global singleton passes stats to end screen  

---

## Known Limitations / Future Enhancements

### Current Implementation
- Audio files are placeholder WAVs (can replace with real audio)
- Single base difficulty (use export vars or presets for variations)
- No achievements or leaderboard

### Future Enhancement Ideas
- 🎵 Full background music loop
- 🏆 Leaderboard/high score system
- 🎨 Cosmetic NPC customization
- 🎮 Difficulty selector in main menu
- 📊 Statistics screen (accuracy %, avg response time)
- 🌍 Mobile touch controls for arm dragging
- 🎯 Combo system (successive correct waves)

---

## Build & Deployment

### Exporting for Distribution
1. **Project** → **Export** → Select template (HTML5, Windows, macOS, Linux)
2. Configure export options in **Project** → **Project Settings** → **Export**
3. Click **Export Project** and choose output directory

### Minimum Requirements
- **OS**: Windows 10+, macOS 10.14+, Linux (modern distros), or web browser (HTML5)
- **RAM**: 256MB
- **Display**: 1024×600 minimum resolution

---

## Changelog

### Version 1.0.0 (Release - Week 4 Complete)
- ✅ Complete gameplay loop (menu → game → end screen)
- ✅ Full physics-based arm control with tunable parameters
- ✅ NPC wave detection system with fake-out logic
- ✅ Vaporwave visual aesthetic with gradient background
- ✅ Audio event system with placeholder WAV files
- ✅ Dynamic difficulty scaling
- ✅ Pause menu & main menu & end-screen
- ✅ Global state management for stats
- ✅ Comprehensive tuning guide & documentation
- ✅ All critical bugs fixed; game fully playable

---

## Troubleshooting

### Game Won't Start
- Ensure Godot 4.5+ is installed
- Check `project.godot` exists in project root
- Verify main scene is set to `res://scenes/MainMenu.tscn`

### Audio Not Playing
- Check `res://sounds/` directory exists and contains WAV files
- Verify `sound_manager.gd` prints "Loaded sound: ..." in console
- Check system volume is not muted

### Physics Too Sluggish/Twitchy
- Adjust `spring_strength` in Player export vars (lower = slower, higher = twitchier)
- See TUNING_GUIDE.md for balanced presets

### NPCs Spawning Too Fast/Slow
- Adjust spawn interval parameters in Main.tscn's DifficultyManager node
- See TUNING_GUIDE.md for difficulty configurations

### Pause Menu Not Working
- Ensure PauseMenu.tscn is instantiated in Main.tscn
- Check that pause_menu.gd script is attached to PauseMenu node
- Verify "ui_cancel" input mapping is enabled in Project Settings

---

## Credits & Inspiration

- **Concept Inspiration**: Bennett Foddy (Getting Over It) – physics-based control
- **Engine**: Godot 4.5 (MIT License)
- **Language**: GDScript
- **Jam Theme**: "WAVES" (physics/gestures/surges)
- **Aesthetic**: Vaporwave genre

---

## License

This project is an independent game jam entry. See project documentation for licensing details.

---

**For detailed gameplay tuning, see `TUNING_GUIDE.md`.**

**Enjoy and happy waving!** 👋
