import * as THREE from "three";

const MAX_ALIVE = 6;
const SPAWN_EVERY = 4;
const HIT_RADIUS = 0.7;
const TOUCH_RADIUS = 1.1;

const bodyMaterial = new THREE.MeshLambertMaterial({ color: 0x1a120c });
const eyeMaterial = new THREE.MeshBasicMaterial({ color: 0xff2200, fog: false });
const bodyGeometry = new THREE.CylinderGeometry(0.18, 0.28, 1.7, 6);
const headGeometry = new THREE.SphereGeometry(0.2, 8, 6);
const eyeGeometry = new THREE.SphereGeometry(0.03, 6, 4);

function buildCorpoSeco() {
  const group = new THREE.Group();
  const body = new THREE.Mesh(bodyGeometry, bodyMaterial);
  const head = new THREE.Mesh(headGeometry, bodyMaterial);
  head.position.y = 1.0;
  group.add(body, head);
  for (const x of [-0.07, 0.07]) {
    const eye = new THREE.Mesh(eyeGeometry, eyeMaterial);
    eye.position.set(x, 1.03, 0.17);
    group.add(eye);
  }
  return group;
}

function createCreatures(scene) {
  const alive = [];
  let spawnTimer = 0;

  function spawn(playerPos) {
    const angle = Math.random() * Math.PI * 2;
    const distance = 14 + Math.random() * 6;
    const mesh = buildCorpoSeco();
    mesh.position.set(
      playerPos.x + Math.cos(angle) * distance,
      playerPos.y - 0.7,
      playerPos.z + Math.sin(angle) * distance
    );
    scene.add(mesh);
    alive.push({ mesh, hp: 3, speed: 1.4 + Math.random() * 0.8 });
  }

  // ponytail: anda em linha reta e atravessa paredes; trocar por navmesh quando o mapa for de verdade
  function update(dt, playerPos, spheres) {
    let kills = 0;
    let touching = 0;

    spawnTimer += dt;
    if (spawnTimer > SPAWN_EVERY && alive.length < MAX_ALIVE) {
      spawnTimer = 0;
      spawn(playerPos);
    }

    for (let i = alive.length - 1; i >= 0; i--) {
      const c = alive[i];
      const target = new THREE.Vector3(playerPos.x, playerPos.y - 0.7, playerPos.z);
      const toPlayer = target.clone().sub(c.mesh.position);
      const distance = toPlayer.length();

      c.mesh.position.addScaledVector(toPlayer.normalize(), c.speed * dt);
      c.mesh.lookAt(target.x, c.mesh.position.y, target.z);
      c.mesh.rotation.z = Math.sin(performance.now() / 180 + i) * 0.06;

      if (distance < TOUCH_RADIUS) touching++;

      for (const s of spheres) {
        if (s.velocity.lengthSq() < 25) continue;
        if (s.collider.center.distanceTo(c.mesh.position.clone().setY(c.mesh.position.y + 0.5)) > HIT_RADIUS) continue;
        s.velocity.set(0, 0, 0);
        s.collider.center.set(0, -100, 0);
        c.hp--;
      }

      if (c.hp <= 0) {
        scene.remove(c.mesh);
        alive.splice(i, 1);
        kills++;
      }
    }

    return { kills, touching };
  }

  return { update };
}

export { createCreatures };
