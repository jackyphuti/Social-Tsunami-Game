import math
import struct
import wave
import os

SAMPLE_RATE = 44100

def write_wav(filename, samples):
    with wave.open(filename, 'wb') as wav:
        wav.setnchannels(1)  # Mono
        wav.setsampwidth(2)  # 16-bit
        wav.setframerate(SAMPLE_RATE)
        # Clamp and pack
        packed = bytearray()
        for s in samples:
            val = max(-1.0, min(1.0, s))
            int_val = int(val * 32767)
            packed.extend(struct.pack('<h', int_val))
        wav.writeframes(packed)

def generate_wave_success():
    # 4-note ascending synth chime: C5 (523), E5 (659), G5 (784), C6 (1046)
    duration = 0.5
    notes = [523.25, 659.25, 783.99, 1046.50]
    samples = []
    note_dur = duration / len(notes)
    
    for i, freq in enumerate(notes):
        num_samples = int(note_dur * SAMPLE_RATE)
        for n in range(num_samples):
            t = n / SAMPLE_RATE
            # Sine + slight second harmonic + triangle
            env = math.exp(-t * 12.0)
            val = (0.7 * math.sin(2 * math.pi * freq * t) +
                   0.3 * math.sin(4 * math.pi * freq * t)) * env
            samples.append(val)
    return samples

def generate_wave_fail():
    # Descending buzz / cringe thud
    duration = 0.45
    num_samples = int(duration * SAMPLE_RATE)
    samples = []
    
    import random
    rng = random.Random(42)
    for n in range(num_samples):
        t = n / SAMPLE_RATE
        freq = 280.0 * math.exp(-t * 4.0) + 70.0
        env = (1.0 - t / duration) ** 1.5
        # Sawtooth / square with noise
        phase = (t * freq) % 1.0
        wave_val = 1.0 if phase < 0.5 else -1.0
        noise = (rng.random() * 2.0 - 1.0) * 0.25
        val = (wave_val * 0.5 + noise) * env
        samples.append(val * 0.7)
    return samples

def generate_fake_out():
    # Sassy 2-note wink/cue sound: E5 (659Hz) -> A5 (880Hz)
    duration = 0.35
    samples = []
    notes = [(659.25, 0.12), (880.0, 0.23)]
    for freq, d in notes:
        num = int(d * SAMPLE_RATE)
        for n in range(num):
            t = n / SAMPLE_RATE
            env = math.exp(-t * 9.0)
            val = math.sin(2 * math.pi * freq * t) * env
            samples.append(val * 0.6)
    return samples

def generate_social_credit_low():
    # Pulsing warning synth alarm
    duration = 0.6
    num_samples = int(duration * SAMPLE_RATE)
    samples = []
    for n in range(num_samples):
        t = n / SAMPLE_RATE
        freq = 350.0 + 100.0 * math.sin(2 * math.pi * 8.0 * t)
        env = 0.7 * (0.5 + 0.5 * math.sin(2 * math.pi * 4.0 * t))
        val = math.sin(2 * math.pi * freq * t) * env
        samples.append(val * 0.6)
    return samples

def generate_game_over():
    # Melancholy 80s descending game-over synth chord: G4 -> F4 -> Eb4 -> C4
    notes = [392.00, 349.23, 311.13, 261.63]
    samples = []
    note_dur = 0.35
    for freq in notes:
        num = int(note_dur * SAMPLE_RATE)
        for n in range(num):
            t = n / SAMPLE_RATE
            env = math.exp(-t * 5.0)
            val = (0.6 * math.sin(2 * math.pi * freq * t) +
                   0.3 * math.sin(2 * math.pi * (freq * 0.5) * t) +
                   0.2 * math.sin(4 * math.pi * freq * t)) * env
            samples.append(val * 0.6)
    return samples

def generate_bg_music():
    # Seamless looping 110 BPM synthwave track (8 bars = ~8.727 seconds)
    # BPM = 110 -> 1 beat = 60/110 = 0.54545 sec
    bpm = 110.0
    beat_dur = 60.0 / bpm
    total_beats = 16  # 4 bars of 4/4
    total_duration = total_beats * beat_dur
    num_samples = int(total_duration * SAMPLE_RATE)
    samples = [0.0] * num_samples
    
    # Chord progression: Am (A2/A3/C4/E4) -> F (F2/F3/A3/C4) -> C (C2/C3/E3/G3) -> G (G2/G3/B3/D4)
    chords = [
        # (root_freq, [chord freqs])
        (110.00, [220.00, 261.63, 329.63]),  # Am
        (87.31,  [174.61, 220.00, 261.63]),  # F
        (65.41,  [130.81, 164.81, 196.00]),  # C
        (98.00,  [196.00, 246.94, 293.66]),  # G
    ]
    
    # 1. Synth bassline (16th notes arpeggiated groove)
    bass_subdiv = 4  # 16th notes
    note_time = beat_dur / bass_subdiv
    for beat in range(total_beats):
        chord_idx = beat // 4
        root, chord = chords[chord_idx]
        for sub in range(bass_subdiv):
            step = beat * bass_subdiv + sub
            t_start = step * note_time
            start_idx = int(t_start * SAMPLE_RATE)
            dur = note_time * 0.8
            n_samples = int(dur * SAMPLE_RATE)
            # Bass octave alternating
            b_freq = root if (sub % 2 == 0) else root * 2
            for n in range(n_samples):
                idx = start_idx + n
                if idx < num_samples:
                    t = n / SAMPLE_RATE
                    env = math.exp(-t * 22.0)
                    # Synth saw/sine bass
                    val = (0.5 * math.sin(2 * math.pi * b_freq * t) +
                           0.3 * math.sin(4 * math.pi * b_freq * t) +
                           0.2 * ((t * b_freq) % 1.0 - 0.5)) * env
                    samples[idx] += val * 0.35

    # 2. Dreamy pad chords on each 4-beat bar
    for chord_idx, (root, freqs) in enumerate(chords):
        start_idx = int(chord_idx * 4 * beat_dur * SAMPLE_RATE)
        chord_samples = int(4 * beat_dur * SAMPLE_RATE)
        for n in range(chord_samples):
            idx = start_idx + n
            if idx < num_samples:
                t = n / SAMPLE_RATE
                # Smooth attack and release envelope
                t_total = 4 * beat_dur
                env = math.sin(math.pi * min(1.0, t / t_total))
                val = 0.0
                for f in freqs:
                    # Detuned dual osc
                    val += math.sin(2 * math.pi * f * t) * 0.3
                    val += math.sin(2 * math.pi * (f * 1.004) * t) * 0.2
                samples[idx] += val * env * 0.15

    # 3. Drum beat: Kick on beats 0, 2; Snare/clap on 1, 3; Hi-hat on 8th notes
    import random
    rng = random.Random(1337)
    for beat in range(total_beats):
        beat_start = int(beat * beat_dur * SAMPLE_RATE)
        
        # Kick drum on beat 0 and 2 (and slight bounce on 2.5)
        kick_steps = [0.0, 2.0, 2.75]
        for ks in kick_steps:
            k_start = beat_start + int(ks * beat_dur * SAMPLE_RATE)
            k_samples = int(0.12 * SAMPLE_RATE)
            for n in range(k_samples):
                idx = k_start + n
                if idx < num_samples:
                    t = n / SAMPLE_RATE
                    k_freq = 120.0 * math.exp(-t * 35.0) + 40.0
                    k_val = math.sin(2 * math.pi * k_freq * t) * math.exp(-t * 25.0)
                    samples[idx] += k_val * 0.45

        # Snare/clap on beats 1 and 3
        for ss in [1.0, 3.0]:
            s_start = beat_start + int(ss * beat_dur * SAMPLE_RATE)
            s_samples = int(0.18 * SAMPLE_RATE)
            for n in range(s_samples):
                idx = s_start + n
                if idx < num_samples:
                    t = n / SAMPLE_RATE
                    noise = (rng.random() * 2.0 - 1.0)
                    tone = math.sin(2 * math.pi * 180.0 * t)
                    s_val = (noise * 0.7 + tone * 0.3) * math.exp(-t * 18.0)
                    samples[idx] += s_val * 0.35

        # Hi-hat on every 8th note
        for h in [0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5]:
            h_start = beat_start + int(h * beat_dur * SAMPLE_RATE)
            h_samples = int(0.04 * SAMPLE_RATE)
            for n in range(h_samples):
                idx = h_start + n
                if idx < num_samples:
                    t = n / SAMPLE_RATE
                    h_val = (rng.random() * 2.0 - 1.0) * math.exp(-t * 80.0)
                    samples[idx] += h_val * 0.12

    return samples

def main():
    sounds_dir = os.path.join(os.path.dirname(__file__), "sounds")
    os.makedirs(sounds_dir, exist_ok=True)
    
    print("Generating wave_success.wav...")
    write_wav(os.path.join(sounds_dir, "wave_success.wav"), generate_wave_success())
    
    print("Generating wave_fail.wav...")
    write_wav(os.path.join(sounds_dir, "wave_fail.wav"), generate_wave_fail())
    
    print("Generating fake_out.wav...")
    write_wav(os.path.join(sounds_dir, "fake_out.wav"), generate_fake_out())
    
    print("Generating social_credit_low.wav...")
    write_wav(os.path.join(sounds_dir, "social_credit_low.wav"), generate_social_credit_low())
    
    print("Generating game_over.wav...")
    write_wav(os.path.join(sounds_dir, "game_over.wav"), generate_game_over())
    
    print("Generating bg_music.wav...")
    write_wav(os.path.join(sounds_dir, "bg_music.wav"), generate_bg_music())
    
    print("All audio files successfully generated!")

if __name__ == "__main__":
    main()
