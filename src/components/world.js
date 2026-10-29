import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader.js";

function loadWorld(scene, worldOctree) {
  const loader = new GLTFLoader().setPath("./models/");
  loader.load("collision-world.glb", (gltf) => {
    scene.add(gltf.scene);
    worldOctree.fromGraphNode(gltf.scene);

    gltf.scene.traverse((child) => {
      if (child.isMesh) {
        child.material.color?.multiplyScalar(0.6).lerp({ r: 0.45, g: 0.3, b: 0.18 }, 0.4);
        if (child.material.map) child.material.map.anisotropy = 4;
      }
    });
  });
}

export { loadWorld };
