import csv
import json
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from generate import ROOT, save_normalized, speech_format, synthesize

PROJECT = ROOT.parent.parent
OUT = PROJECT / "resources" / "voices"
SPEAKER_CHARACTER = {
    "SPEAKER_LAMPIAO": "lampiao",
    "SPEAKER_MARIA": "maria",
    "SPEAKER_VINI": "vini",
    "SPEAKER_CORONEL": "coronel",
    "SPEAKER_ELA": "ela",
    "SPEAKER_SOLDADO": "soldado",
    "SPEAKER_SOLDADOS": "soldado",
    "SPEAKER_CANGACEIRO": "cangaceiro",
}
UNNAMED_SPEAKER = {
    "CH01_OPENING_01": "lampiao",
    "CH01_OPENING_02": "lampiao",
    "CH01_OPENING_03": "lampiao",
    "CH01_RAID_05": "cangaceiro",
    "CH01_STREET_02": "soldado",
    "CH01_RIDE_01": "vini",
    "CH01_RIDE_02": "cangaceiro",
    "CH01_RIDE_04": "cangaceiro",
    "CH01_RIDE_05": "vini",
    "CH01_RIDE_06": "cangaceiro",
    "CH01_ENTITY_01": "soldado",
}
CHARACTER = {
    "lampiao": "rough northeastern Brazilian cangaceiro leader in his thirties",
    "maria": "brave young northeastern Brazilian woman",
    "vini": "young northeastern Brazilian man, nervous",
    "coronel": "very deep bass voice, gravelly cigar smoker, older powerful landowner",
    "ela": "ancient deep demonic voice, like a symbiote monster",
    "soldado": "young frightened Brazilian soldier",
    "cangaceiro": "hoarse rough northeastern Brazilian bandit",
}
MOOD = {
    "CH01_OPENING_01": "calm solemn narration",
    "CH01_OPENING_02": "calm solemn narration",
    "CH01_OPENING_03": "calm solemn narration, proud",
    "CH01_OPENING_CARD": "calm solemn narration, proud",
    "CH01_STREET_09": "wounded, in pain but smiling",
    "CH01_CAMP_03": "playful, proud, teasing",
    "CH01_CAMP_04": "excited, laughing",
    "CH01_CAMP_05": "excited, laughing",
    "CH01_CAMP_09": "cheerful, friendly, laughing",
    "CH01_CAMP_10": "warm, friendly",
    "CH01_HALL_04": "crying, ashamed",
    "CH01_HALL_05": "crying, terrified, voice breaking",
    "CH01_HALL_06": "crying, pleading",
    "CH01_BEHEADING_02": "cruel, mocking laugh",
    "CH01_BEHEADING_04": "cruel, mocking laugh",
    "CH01_BEHEADING_08": "slow, sinister whisper",
    "CH01_BEHEADING_10": "slow, sinister, ancient whisper",
    "CH01_BEHEADING_13": "slow, sinister",
    "CH01_BEHEADING_14": "slow, sinister, rising",
    "CH01_BEHEADING_15": "triumphant, sinister",
    "CH01_ENTITY_04": "ravenous, roaring",
    "CH01_ROSARY_02": "agonized scream",
    "CH01_ROSARY_03": "stunned, breathless whisper",
    "CH01_ROSARY_04": "annoyed, mocking",
    "CH01_ROSARY_06": "smug, sarcastic",
    "CH01_RETURN_01": "quiet, numb",
    "CH01_MARIA_02": "desperate, grieving, voice breaking",
    "CH01_MARIA_03": "desperate, sobbing, shouting",
    "CH01_MARIA_04": "broken, sobbing whisper",
    "CH01_BURIAL_01": "furious oath, screaming",
    "CH01_BURIAL_02": "grieving, quiet",
    "CH01_BURIAL_03": "grieving, quiet",
    "CH01_BURIAL_04": "disgusted, sarcastic",
    "CH01_BURIAL_05": "bored, mocking, hungry",
    "CH01_BURIAL_06": "tired, stern",
    "CH01_BURIAL_09": "disgusted",
}
CHARACTER_VOICE = {"cangaceiro": "fish-audio/drama-3|default"}


def mood(key, text):
    if key in MOOD:
        return MOOD[key]
    if "!!" in text:
        return "shouting, intense"
    if "?!" in text:
        return "shocked"
    if text.endswith("..."):
        return "hesitant, quiet"
    if text.endswith("!"):
        return "urgent"
    return "tense"


def direction(model, character, line_mood, text):
    if model == "elevenlabs/eleven-v4":
        return text
    return f"[{CHARACTER[character]}, {line_mood}] {text}"


def voice_of(character, cast):
    choice = CHARACTER_VOICE.get(character) or cast[character]["default"]
    model, voice = choice.split("|")
    return model, None if voice == "default" else voice


def line_jobs():
    texts = {row[0]: row[1] for row in csv.reader(open(PROJECT / "i18n" / "strings.csv", encoding="utf-8"))}
    speakers = json.loads((ROOT / "speakers.json").read_text())
    speakers["CH01_OPENING_CARD"] = ""
    for key, speaker in speakers.items():
        character = SPEAKER_CHARACTER.get(speaker) or UNNAMED_SPEAKER.get(key) or "lampiao"
        yield key, character, texts[key]


def render(job, cast):
    key, character, text = job
    target = OUT / f"{key}.ogg"
    if target.exists():
        return key
    model, voice = voice_of(character, cast)
    data = synthesize(model, voice, direction(model, character, mood(key, text), text))
    if not data:
        return None
    save_normalized(data, speech_format(model), target)
    return key


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    cast = json.loads((ROOT / "cast.json").read_text())
    with ThreadPoolExecutor(max_workers=6) as pool:
        done = [k for k in pool.map(lambda job: render(job, cast), list(line_jobs())) if k]
    print(len(done), "lines")


if __name__ == "__main__":
    main()
