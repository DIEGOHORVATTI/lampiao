import * as THREE from "three";

// Components
import { createScene } from "./components/scene";
import { createCamera, gunMixer } from "./components/camera";
import { createLights, createLantern } from "./components/lights";
import { loadWorld } from "./components/world";
import { playAmbientMusic } from "./components/music";
import { createCreatures } from "./components/creatures";

// Systems
import { createRenderer } from "./systems/renderer";
import { Resizer } from "./systems/resizer";

// Physics & Controls
import { createPhysics, STEPS_PER_FRAME } from "./systems/physics";
import { setupControls } from "./systems/controls";

const HUNGER_PER_SECOND = 2.5;
const HUNGER_PER_KILL = 25;
const DAMAGE_PER_SECOND = 35;

const clock = new THREE.Clock();
const scene = createScene();
const { camera } = createCamera(scene);
const { fillLight1, directionalLight } = createLights();
scene.add(fillLight1, directionalLight);
const flickerLantern = createLantern(camera);

const container = document.getElementById("container");
const renderer = createRenderer(animate);
container.appendChild(renderer.domElement);

const { playerCollider, playerVelocity, playerDirection, updatePlayer, updateSpheres, throwBall, worldOctree, spheres } =
  createPhysics(scene);

const applyControls = setupControls(camera, playerVelocity, throwBall, playerDirection);
const creatures = createCreatures(scene);

loadWorld(scene, worldOctree);

// Game state & HUD
const hud = {
  overlay: document.getElementById("overlay"),
  message: document.getElementById("message"),
  health: document.getElementById("health"),
  hunger: document.getElementById("hunger"),
  kills: document.getElementById("kills"),
  damage: document.getElementById("damage"),
};
const state = { health: 100, hunger: 0, kills: 0, over: false };

document.addEventListener("pointerlockchange", () => {
  const locked = document.pointerLockElement === document.body;
  if (locked) playAmbientMusic();
  if (!state.over) hud.overlay.classList.toggle("hidden", locked);
});

hud.overlay.addEventListener("click", () => {
  if (state.over) location.reload();
});

function endGame(message) {
  state.over = true;
  hud.message.textContent = message;
  hud.overlay.querySelector(".hint").textContent = "Clique para tentar de novo";
  hud.overlay.classList.remove("hidden");
  document.exitPointerLock();
}

function updateGame(dt) {
  const { kills, touching } = creatures.update(dt, camera.position, spheres);

  state.kills += kills;
  state.hunger = Math.max(0, state.hunger + HUNGER_PER_SECOND * dt - kills * HUNGER_PER_KILL);
  state.health = Math.max(0, state.health - touching * DAMAGE_PER_SECOND * dt);

  hud.health.value = state.health;
  hud.hunger.value = state.hunger;
  hud.kills.textContent = state.kills;
  hud.damage.style.opacity = touching ? 1 : 0;

  if (state.health <= 0) endGame("O sertão te engoliu. Nem o Encosto te segura de pé.");
  else if (state.hunger >= 100) endGame("Você não alimentou o Encosto. Agora ele come você.");
}

// Animation Loop
function animate() {
  const frameDelta = Math.min(0.05, clock.getDelta());
  flickerLantern(clock.elapsedTime);

  if (document.pointerLockElement === document.body && !state.over) {
    const deltaTime = frameDelta / STEPS_PER_FRAME;
    for (let i = 0; i < STEPS_PER_FRAME; i++) {
      applyControls(deltaTime, playerCollider.onFloor, camera);
      updatePlayer(deltaTime, worldOctree, camera);
      updateSpheres(deltaTime, worldOctree);
    }
    updateGame(frameDelta);
  }

  if (gunMixer) gunMixer.update(frameDelta / STEPS_PER_FRAME);

  renderer.render(scene, camera);
}

Resizer(camera, renderer);
