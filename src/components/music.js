const ambientSounds = [
  new Audio("/sounds/ambience1.mp3"),
  new Audio("/sounds/ambience2.mp3"),
  new Audio("/sounds/ambience3.mp3"),
];

ambientSounds.forEach((sound) => {
  sound.loop = true;
  sound.volume = 0.5;
});

function playAmbientMusic() {
  ambientSounds.forEach((sound) => {
    if (sound.paused) sound.play().catch((err) => console.warn("Audio play failed:", err));
  });
}

export { playAmbientMusic };
