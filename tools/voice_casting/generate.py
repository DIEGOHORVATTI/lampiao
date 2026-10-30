import json
import os
import subprocess
import urllib.error
import urllib.request
import wave
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path(__file__).parent
OUT = ROOT / "out"
ENDPOINT = "https://openrouter.ai/api/v1/audio/speech"
SAMPLE_RATE = 24000


def direction(model, mood, text):
    if model.startswith("google/"):
        return f"Say in Brazilian Portuguese, {mood}: {text}"
    if model == "elevenlabs/eleven-v4":
        return text
    return f"[{mood}] {text}"


def speech_format(model):
    return "pcm" if model.startswith("google/") else "mp3"


def synthesize(model, voice, text):
    body = {"model": model, "input": text, "response_format": speech_format(model)}
    if voice:
        body["voice"] = voice
    headers = {"Authorization": f"Bearer {os.environ['OPENROUTER_API_KEY']}", "Content-Type": "application/json"}
    request = urllib.request.Request(ENDPOINT, json.dumps(body).encode(), headers)
    try:
        return urllib.request.urlopen(request, timeout=180).read()
    except urllib.error.HTTPError as error:
        print(model, voice, error.code, error.read()[:200])
        return None


def save_normalized(data, fmt, target):
    raw = target.with_suffix(".src." + fmt)
    if fmt == "pcm":
        raw = target.with_suffix(".raw.wav")
        with wave.open(str(raw), "wb") as w:
            w.setnchannels(1)
            w.setsampwidth(2)
            w.setframerate(SAMPLE_RATE)
            w.writeframes(data)
    else:
        raw.write_bytes(data)
    subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-i", str(raw), "-af", "loudnorm=I=-16:TP=-1.5", "-ar", "44100", "-b:a", "160k", str(target)], check=True)
    raw.unlink()


def take(job):
    character, line_index, model, voice, mood, text = job
    slug = f"{character}-{line_index}-{model.split('/')[1]}-{voice or 'default'}"
    target = OUT / f"{slug}.mp3"
    if not target.exists():
        data = synthesize(model, voice, direction(model, mood, text))
        if not data:
            return None
        save_normalized(data, speech_format(model), target)
    return {"character": character, "line": line_index, "model": model, "voice": voice or "default", "file": f"out/{target.name}"}


def jobs(cast):
    for character, spec in cast.items():
        for line_index, (mood, text) in enumerate(spec["lines"]):
            for model, voices in spec["voices"].items():
                for voice in voices:
                    yield character, line_index, model, voice, mood, text


def main():
    OUT.mkdir(exist_ok=True)
    cast = json.loads((ROOT / "cast.json").read_text())
    with ThreadPoolExecutor(max_workers=6) as pool:
        takes = [t for t in pool.map(take, list(jobs(cast))) if t]
    (ROOT / "takes.json").write_text(json.dumps(takes, ensure_ascii=False, indent=1))
    print(len(takes), "takes")


if __name__ == "__main__":
    main()
