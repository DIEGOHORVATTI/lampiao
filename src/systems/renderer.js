import { WebGLRenderer, ACESFilmicToneMapping } from "three";

function createRenderer(animate) {
  const renderer = new WebGLRenderer({ antialias: true });
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.setAnimationLoop(animate);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 1.5));
  renderer.toneMapping = ACESFilmicToneMapping;
  return renderer;
}

export { createRenderer };
