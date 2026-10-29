import { HemisphereLight, DirectionalLight, PointLight } from "three";

function createLights() {
  const fillLight1 = new HemisphereLight(0x223344, 0x0a0805, 0.15);

  const directionalLight = new DirectionalLight(0x8899cc, 0.25);
  directionalLight.position.set(-5, 25, -1);

  return { fillLight1, directionalLight };
}

function createLantern(camera) {
  const lantern = new PointLight(0xff9933, 8, 16, 1.6);
  lantern.position.set(0.3, -0.2, -0.3);
  camera.add(lantern);

  return function flicker(time) {
    lantern.intensity = 7 + Math.sin(time * 9) * 0.6 + Math.random() * 1.2;
  };
}

export { createLights, createLantern };
