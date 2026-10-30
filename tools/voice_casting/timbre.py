import json
import subprocess
import sys
import tempfile
from pathlib import Path

import numpy as np
from resemblyzer import VoiceEncoder, preprocess_wav

from generate import ROOT, save_normalized, speech_format, synthesize
from lines import OUT, direction, line_jobs, mood, voice_of

THRESHOLD = 0.82
ATTEMPTS = 4
encoder = VoiceEncoder("cpu")


def embed(path):
    with tempfile.NamedTemporaryFile(suffix=".wav") as wav:
        subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-i", str(path), "-ar", "16000", "-ac", "1", wav.name], check=True)
        return encoder.embed_utterance(preprocess_wav(wav.name))


def reference(character, cast, lines_by_character):
    if character in cast:
        model, voice = cast[character]["default"].split("|")
        sample = ROOT / "out" / f"{character}-0-{model.split('/')[1]}-{voice}.mp3"
        if sample.exists():
            return embed(sample)
    vectors = [embed(OUT / f"{key}.ogg") for key, _ in lines_by_character[character]]
    centroid = np.mean(vectors, axis=0)
    return centroid / np.linalg.norm(centroid)


def retake(key, character, text, cast, ref):
    model, voice = voice_of(character, cast)
    best = None
    for _ in range(ATTEMPTS):
        data = synthesize(model, voice, direction(model, character, mood(key, text), text))
        if not data:
            continue
        candidate = Path(tempfile.mkdtemp()) / f"{key}.ogg"
        save_normalized(data, speech_format(model), candidate)
        score = float(np.dot(embed(candidate), ref))
        if best is None or score > best[0]:
            best = (score, candidate)
        if score >= THRESHOLD:
            break
    return best


def main():
    fix = "--fix" in sys.argv
    cast = json.loads((ROOT / "cast.json").read_text())
    lines_by_character = {}
    for key, character, text in line_jobs():
        lines_by_character.setdefault(character, []).append((key, text))
    report = {}
    for character, lines in lines_by_character.items():
        ref = reference(character, cast, lines_by_character)
        for key, text in lines:
            score = float(np.dot(embed(OUT / f"{key}.ogg"), ref))
            if score < THRESHOLD and fix:
                best = retake(key, character, text, cast, ref)
                if best and best[0] > score:
                    best[1].replace(OUT / f"{key}.ogg")
                    print(f"{key} {character} {score:.2f} -> {best[0]:.2f}")
                    score = best[0]
            report[key] = {"character": character, "similarity": round(score, 3)}
    (ROOT / "timbre_report.json").write_text(json.dumps(report, ensure_ascii=False, indent=1))
    low = {k: v for k, v in report.items() if v["similarity"] < THRESHOLD}
    print(len(report), "lines,", len(low), "below", THRESHOLD)
    for k, v in sorted(low.items(), key=lambda i: i[1]["similarity"]):
        print(" ", k, v["character"], v["similarity"])


if __name__ == "__main__":
    main()
