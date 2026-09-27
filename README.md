# Social Tsunami - Game Project

**A vaporwave-aesthetic social anxiety simulator about mastering the art of the wave.**

---

## 📥 Download the Game (Windows)

Non-gamers: you **do not** need Godot or any coding tools installed to play!

| Download Option | Link |
|---|---|
| 📦 **Windows Setup Wizard (.exe)** | [**Download Social_Tsunami_Setup.exe**](https://github.com/jackyphuti/Social-Tsunami-Game/releases/download/v1.0.0/Social_Tsunami_Setup.exe) |
| 📁 **Portable Version (.zip)** | [**Download SocialTsunami_Portable.zip**](https://github.com/jackyphuti/Social-Tsunami-Game/releases/download/v1.0.0/SocialTsunami_Portable.zip) |
| 🏷️ **Release v1.0.0 Page** | [**View Release v1.0.0 on GitHub**](https://github.com/jackyphuti/Social-Tsunami-Game/releases/tag/v1.0.0) |
| 📜 **All Releases** | [**View All GitHub Releases**](https://github.com/jackyphuti/Social-Tsunami-Game/releases) |

---

## 🚀 Quick Install & Play Guide (For Non-Gamers)

Choose whichever option is easiest for you:

### Option 1: Standard Windows Setup Wizard (Recommended)
1. Download **`Social_Tsunami_Setup.exe`** from the link above (or from `installer_output/`).
2. Double-click **`Social_Tsunami_Setup.exe`**.
3. Follow the friendly wizard (*Next -> Install -> Finish*).
4. A **Social Tsunami** shortcut is created directly on your **Desktop** and in your **Start Menu**!
5. Double-click the Desktop shortcut to play anytime!

### Option 2: 1-Click Native Installer
1. In the main game directory, simply double-click **`Install_Social_Tsunami.bat`**.
2. It automatically sets up the game in your user programs directory, creates Desktop & Start Menu shortcuts, and offers to launch the game immediately.

### Option 3: Portable / No Install
1. Open the `dist/` folder.
2. Double-click **`SocialTsunami.exe`**.
3. The game starts immediately in high-definition 1280×720!

*(To uninstall at any time: run `Uninstall.bat` in `%LOCALAPPDATA%\Programs\Social Tsunami` or use Windows Add/Remove Programs).*

---

## 🎮 Game Concept & Rules

In **Social Tsunami**, you control a springy, physics-driven ragdoll arm with your mouse to respond to oncoming pedestrians in a neon 80s vaporwave city. But be careful: misreading social cues leads to massive embarrassment!

### Controls

| Input | Action |
|-------|--------|
| **Left Mouse Button (Hold & Drag)** | Reach and wave your floppy arm back and forth |
| **ESC** | Pause / Resume game |

---

## 👥 NPC Archetypes & Social Cues

Pay attention to speech bubbles and arm gestures as pedestrians approach:

- 👋 **Genuine Waver**:
  - Speech: *"👋 Hey!"*, *"👋 Yo!"*, *"👋 Hello!"*
  - Gesture: Waves arm high back and forth.
  - **Your Action**: **WAVE BACK!**
  - **Result**: +Points, +Social Credit, +Streak multiplier!

- 💇 **Hair-Flipper / Fake-Out**:
  - Speech: *"💇 \*flips hair\*"*, *"🕶️ \*shades check\*"*
  - Gesture: Raises arm to touch hair or sunglasses.
  - **Your Action**: **DO NOT WAVE!**
  - **Result**: Successfully dodged (+Points, +Streak)! If you wave back: **CRINGE!** (-15 Social Credit, +15 Embarrassment).

- 👤 **Friend Behind You**:
  - Speech: *"👤 Behind you!"*, *"👤 Dave! Over here!"*
  - Gesture: Waves and points past your head at someone behind you.
  - **Your Action**: **DO NOT WAVE!**
  - **Result**: Successfully dodged! If you wave back: **THEY WEREN'T WAVING AT YOU!** (Massive embarrassment).

- ✨ **VIP Golden Waver** (Rare!):
  - Speech: *"✨ YOOOO!! ✨"*
  - Appearance: Glowing golden neon aura.
  - **Your Action**: **WAVE ENTHUSIASTICALLY!**
  - **Result**: +35 Points, +10 Social Credit, +2 Streak boost!

---

## 📊 Scoring & Progression

- **Social Credit**: Starts at 100. If it reaches 0, it's Game Over!
- **Embarrassment Meter**: Rises when you cringe or ignore real waves.
- **Streak & Multiplier**: Consecutive successful waves and dodges boost your score multiplier up to **4x** and pitch-shift the success chime higher!
- **Social Anxiety Ranks**:
  - 0–49: *Social Hermit 🦔*
  - 50–149: *Awkward Acquaintance 😬*
  - 150–299: *Casual Greeter 🙂*
  - 300–499: *Vaporwave Socialite 😎*
  - 500+: *Wave God / Legend ✨👑*

---

## 🕹️ Project Structure

```
Social-Tsunami-Game/
├── dist/                         # Portable standalone game bundle
│   ├── SocialTsunami.exe         # Standalone Windows executable
│   └── SocialTsunami.pck         # Compiled game package
│
├── installer_output/             # Compiled Windows Setup installer
│   └── Social_Tsunami_Setup.exe  # Standard Windows Setup Wizard
│
├── scenes/
│   ├── Main.tscn                 # Main gameplay stage
│   ├── Player.tscn               # Ragdoll arm & character
│   ├── NPC.tscn                  # Pedestrian with speech bubble & gestures
│   ├── MainMenu.tscn             # Title screen & tutorial modal
│   ├── PauseMenu.tscn            # Pause menu overlay (ESC)
│   └── EndScreen.tscn            # Game over stats & rank card
│
├── scripts/
│   ├── player.gd                 # Arm spring physics & walking bob
│   ├── npc.gd                    # Archetypes, speech cues & resolution
│   ├── npc_spawner.gd            # Dynamic spawning system
│   ├── wave_detector.gd          # Continuous motion & oscillation detector
│   ├── game_manager.gd           # Scoring, multipliers & game loop
│   ├── ui_manager.gd             # Vaporwave HUD & alert banners
│   ├── visual_feedback.gd        # Camera shake, flashes & floating text
│   ├── difficulty_manager.gd     # Dynamic spawn interval scaling
│   ├── sound_manager.gd          # Audio playback & pitch shifting
│   ├── vaporwave_background.gd   # Animated 3D grid, retro sunset & stars
│   ├── procedural_sprite_gen.gd  # Pastel color palettes & styles
│   ├── main_menu.gd              # Main menu controller
│   ├── pause_menu.gd             # Pause controller (PROCESS_MODE_ALWAYS)
│   ├── end_screen.gd             # Stats display & restart logic
│   └── global.gd                 # Save data & stats persistence singleton
│
├── sounds/                       # Synthesized 16-bit retro WAV audio
│   ├── bg_music.wav              # 110 BPM looping synthwave track
│   ├── wave_success.wav          # Ascending synth chime
│   ├── wave_fail.wav             # Cringe buzz / fail splat
│   ├── fake_out.wav              # Sassy 2-note cue
│   ├── social_credit_low.wav     # Heartbeat warning alarm
│   └── game_over.wav             # Melancholy 80s fanfare
│
├── tests/
│   └── test_gameplay.gd          # Automated integration test suite
│
├── Install_Social_Tsunami.bat    # Native 1-click Windows installer
├── build_game.bat                # Automated build & packaging script
├── setup.iss                     # Inno Setup compiler script
└── project.godot                 # Godot 4.7 project configuration
```

---

## 🛠️ For Developers

### Requirements
- **Godot 4.5+** (tested on Godot 4.7.2 stable)
- **Windows / macOS / Linux**

### Run via Command Line
```powershell
godot res://scenes/MainMenu.tscn
```

### Run Automated Tests
```powershell
godot --headless -s tests/test_gameplay.gd
```

### Rebuild Standalone & Installer
```powershell
.\build_game.bat
```
