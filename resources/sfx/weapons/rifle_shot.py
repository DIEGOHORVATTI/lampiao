import math, random, struct, sys, wave

RATE = 44100
LENGTH = 2.6
N = int(RATE * LENGTH)
random.seed(1927)


def noise():
    return [random.uniform(-1, 1) for _ in range(N)]


def lowpass(x, cutoff):
    out, y = [], 0.0
    for i, s in enumerate(x):
        c = cutoff(i) if callable(cutoff) else cutoff
        a = 1 - math.exp(-2 * math.pi * c / RATE)
        y += a * (s - y)
        out.append(y)
    return out


def highpass(x, cutoff):
    low = lowpass(x, cutoff)
    return [s - l for s, l in zip(x, low)]


def envelope(attack, decay, start=0.0):
    out = []
    for i in range(N):
        t = i / RATE - start
        if t < 0:
            out.append(0.0)
        elif t < attack:
            out.append(t / attack)
        else:
            out.append(math.exp(-(t - attack) / decay))
    return out


def mix(*layers):
    return [sum(v) for v in zip(*layers)]


def scale(x, gain, env=None):
    return [s * gain * (env[i] if env else 1.0) for i, s in enumerate(x)]


def crack():
    out = [0.0] * N
    width = int(RATE * 0.0012)
    for i in range(width * 2):
        out[i] = 1.0 - i / width
    hiss = highpass(noise(), 2500)
    return mix(scale(out, 0.9), scale(hiss, 1.4, envelope(0.0002, 0.006)))


def blast():
    body = lowpass(noise(), lambda i: 200 + 2600 * math.exp(-i / (RATE * 0.03)))
    body = lowpass(body, 1800)
    return scale(body, 7.0, envelope(0.0008, 0.045))


def thump():
    out, phase = [], 0.0
    for i in range(N):
        t = i / RATE
        phase += 2 * math.pi * (48 + 70 * math.exp(-t / 0.03)) / RATE
        out.append(math.sin(phase))
    return scale(out, 0.9, envelope(0.002, 0.085))


def steep(x, cutoff, poles=4):
    for _ in range(poles):
        x = lowpass(x, cutoff)
    return x


def tail():
    rumble = steep(noise(), 300)
    return scale(rumble, 2.2, envelope(0.04, 0.5, 0.015))


def echoes(dry):
    out = [0.0] * N
    for delay, gain, cutoff in [(0.31, 0.2, 900), (0.74, 0.12, 600), (1.25, 0.07, 400)]:
        shifted = [0.0] * int(delay * RATE) + dry[: N - int(delay * RATE)]
        out = mix(out, scale(steep(shifted, cutoff, 3), gain))
    return out


def saturate(x, drive):
    return [math.tanh(s * drive) for s in x]


def fade(x, seconds):
    count = int(seconds * RATE)
    return [s * min(1.0, (N - i) / count) for i, s in enumerate(x)]


def normalize(x, peak):
    top = max(abs(s) for s in x)
    return [s / top * peak for s in x]


def write(path, x):
    with wave.open(path, "wb") as f:
        f.setnchannels(1)
        f.setsampwidth(2)
        f.setframerate(RATE)
        f.writeframes(b"".join(struct.pack("<h", int(s * 32767)) for s in x))


dry = mix(crack(), blast(), thump())
shot = mix(saturate(dry, 1.2), tail(), echoes(dry))
write(sys.argv[1], normalize(fade(shot, 0.4), 0.93))
