import { Scene, Color, FogExp2 } from "three";

function createScene() {
  const scene = new Scene();
  scene.background = new Color(0x050403);
  scene.fog = new FogExp2(0x0b0907, 0.07);
  return scene;
}

export { createScene };
