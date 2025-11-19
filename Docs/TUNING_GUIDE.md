# Social Tsunami - Parameter Tuning Guide

This guide provides recommended tuning parameters for gameplay balance and difficulty progression.

## 1. Player Arm Control (scripts/player.gd)

### walk_speed
- **Current:** 120.0 units/sec
- **Range:** 100-150 units/sec
- **Effect:** How fast the player walks left-to-right across the screen
- **Tuning:** Decrease for more time to react; increase for challenge

### spring_strength
- **Current:** 25.0
- **Range:** 15-35
- **Effect:** How responsive the hand is to mouse movement (spring constant)
- **Tuning:** Higher = more snappy/twitchy; lower = sluggish/floaty

### hand_mass
- **Current:** 0.3 (light)
- **Range:** 0.2-0.5
- **Effect:** Inertia of the hand physics
- **Tuning:** Higher = heavier/harder to move; lower = easier/quicker response

**Recommended Settings:**
- **Easy:** walk_speed=100, spring_strength=30, hand_mass=0.2
- **Normal:** walk_speed=120, spring_strength=25, hand_mass=0.3
- **Hard:** walk_speed=140, spring_strength=20, hand_mass=0.4

---

## 2. NPC Behavior (scripts/npc.gd)

### walk_speed
- **Current:** 60.0 units/sec
- **Range:** 40-100 units/sec
- **Effect:** How fast NPCs walk toward the player
- **Tuning:** Higher = less time to react to waves

### wave_duration
- **Current:** 1.5 seconds
- **Range:** 1.0-2.5 seconds
- **Effect:** How long an NPC stays in waving state
- **Tuning:** Shorter = smaller window to catch wave; longer = more forgiving

### fake_out_chance
- **Current:** 0.3 (30%)
- **Range:** 0.1-0.6 (10%-60%)
- **Effect:** Probability that an NPC is a "hair flip" fake-out
- **Tuning:** Higher = more unpredictability; lower = easier to identify real waves

**Recommended Settings:**
- **Easy:** walk_speed=50, wave_duration=2.0, fake_out_chance=0.2
- **Normal:** walk_speed=60, wave_duration=1.5, fake_out_chance=0.3
- **Hard:** walk_speed=80, wave_duration=1.0, fake_out_chance=0.5

---

## 3. Difficulty Scaling (scripts/difficulty_manager.gd)

### spawn_interval_start
- **Current:** 2.0 seconds
- **Range:** 1.5-3.0 seconds
- **Effect:** Starting delay between NPC spawns
- **Tuning:** Lower = more NPCs right away (harder start)

### spawn_interval_min
- **Current:** 0.8 seconds
- **Range:** 0.5-1.2 seconds
- **Effect:** Minimum spawn interval (hardest difficulty)
- **Tuning:** Lower = NPCs spawn faster at endgame

### difficulty_scale_rate
- **Current:** 0.02 (2% per second)
- **Range:** 0.01-0.05
- **Effect:** How fast the game ramps up in difficulty
- **Tuning:** Higher = faster ramp (shorter games); lower = slower progression

**Example:**
At rate 0.02 with start 2.0 and min 0.8:
- 0s: 2.0s spawn interval (1 NPC every 2 seconds)
- 30s: 1.4s spawn interval (1 NPC every 1.4 seconds)
- 60s: 0.8s spawn interval (1 NPC every 0.8 seconds = max difficulty)

---

## 4. Scoring & Meters (scripts/game_manager.gd)

### correct_wave_score
- **Current:** 10 points
- **Range:** 5-20 points
- **Effect:** Score reward for correct wave detection
- **Tuning:** Higher = more score incentive

### correct_wave_credit
- **Current:** 5.0 credit
- **Range:** 2-10 credit
- **Effect:** Social credit gain on correct wave
- **Tuning:** Higher = easier to maintain social credit

### wrong_wave_embarrassment
- **Current:** 10.0 embarrassment
- **Range:** 5-20 embarrassment
- **Effect:** Embarrassment penalty for wrong/missed wave
- **Tuning:** Higher = faster embarrassment growth

### wrong_wave_credit
- **Current:** 15.0 credit loss
- **Range:** 5-25 credit loss
- **Effect:** Social credit penalty on wrong/missed wave
- **Tuning:** Higher = faster social credit depletion (game over)

### social_credit_warning_threshold
- **Current:** 25.0
- **Range:** 15-40
- **Effect:** When warning sound plays (below this credit)
- **Tuning:** Higher = earlier warning

**Game Over Condition:** Social credit ≤ 0

**Recommended Settings:**
- **Easy:** correct_score=15, correct_credit=8, wrong_emb=8, wrong_credit=10, warning=40
- **Normal:** correct_score=10, correct_credit=5, wrong_emb=10, wrong_credit=15, warning=25
- **Hard:** correct_score=8, correct_credit=3, wrong_emb=15, wrong_credit=20, warning=15

---

## 5. Testing Procedure

### Balance Testing Checklist:
1. **Test Easy Mode:** Can a new player succeed?
2. **Test Normal Mode:** Is ~5-10 minutes a typical game?
3. **Test Hard Mode:** Is there a clear skill ceiling?
4. **Test Difficulty Curve:** Does the game feel fair through all stages?
5. **Test End Condition:** Does game-over feel satisfying/fair?

### Metrics to Track:
- Average game duration
- Average final score
- Win/lose ratio at different difficulties
- Embarrassment meter growth rate
- Social credit depletion rate

---

## 6. Quick Presets

### Chill Mode (Very Easy)
```
Player: walk=100, spring=30, mass=0.2
NPC: walk=40, duration=2.5, fake=0.15
Difficulty: start=3.0, min=1.5, rate=0.01
Scoring: score=15, credit=8, emb=5, loss=8
```

### Arcade Mode (Hard)
```
Player: walk=150, spring=18, mass=0.5
NPC: walk=90, duration=1.0, fake=0.6
Difficulty: start=1.5, min=0.5, rate=0.04
Scoring: score=8, credit=3, emb=15, loss=20
```

### Speedrun Mode (Fast Games)
```
Player: walk=200, spring=35, mass=0.2
NPC: walk=100, duration=0.8, fake=0.4
Difficulty: start=0.8, min=0.3, rate=0.08
Scoring: score=20, credit=10, emb=20, loss=25
```

---

## 7. Notes

- All timing parameters assume 60 FPS gameplay
- Test on target hardware to verify frame rate doesn't affect timing
- Use Godot's debugger to monitor spawn rates and meter changes
- Save custom presets in project export vars for easy switching
