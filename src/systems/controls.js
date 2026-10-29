import * as THREE from "three";

function setupControls(camera, playerVelocity, throwBall, playerDirection) {
  const keyStates = {};

  document.addEventListener(
    "keydown",
    (event) => (keyStates[event.code] = true)
  );
  document.addEventListener(
    "keyup",
    (event) => (keyStates[event.code] = false)
  );

  const isTouch = matchMedia("(pointer: coarse)").matches;
  if (!isTouch) document.body.addEventListener("click", () => document.body.requestPointerLock());

  const touch = setupTouch(camera, () => throwBall(camera, playerDirection));

  // ✅ Pass `playerDirection` correctly
  document.body.addEventListener("mousedown", () => {
    if (document.pointerLockElement === document.body) {
      throwBall(camera, playerDirection); // ✅ FIX: Pass playerDirection
    }
  });

  document.body.addEventListener("mousemove", (event) => {
    if (document.pointerLockElement === document.body) {
      camera.rotation.y -= event.movementX / 500;
      camera.rotation.x -= event.movementY / 500;
    }
  });

  function applyControls(deltaTime, playerOnFloor, camera) {
    const speedDelta = deltaTime * (playerOnFloor ? 25 : 8);

    // ✅ Manually update the camera's world matrix
    camera.updateMatrixWorld();

    const forward = new THREE.Vector3();
    const side = new THREE.Vector3();

    // ✅ Use matrixWorld here safely
    if (camera.matrixWorld) {
      forward.setFromMatrixColumn(camera.matrixWorld, 0);
      forward.crossVectors(camera.up, forward).normalize();

      side.setFromMatrixColumn(camera.matrixWorld, 0).normalize();
    }

    if (keyStates["KeyW"])
      playerVelocity.add(forward.clone().multiplyScalar(speedDelta));
    if (keyStates["KeyS"])
      playerVelocity.add(forward.clone().multiplyScalar(-speedDelta));
    if (keyStates["KeyA"])
      playerVelocity.add(side.clone().multiplyScalar(-speedDelta));
    if (keyStates["KeyD"])
      playerVelocity.add(side.clone().multiplyScalar(speedDelta));

    playerVelocity.add(forward.clone().multiplyScalar(-touch.y * speedDelta));
    playerVelocity.add(side.clone().multiplyScalar(touch.x * speedDelta));

    if (playerOnFloor && keyStates["Space"]) playerVelocity.y = 15;
  }

  return applyControls;
}

const JOY_RADIUS = 60;

function setupTouch(camera, fire) {
  const touch = { x: 0, y: 0 };
  const stick = document.getElementById("stick");
  let move = null;
  let look = null;

  document.getElementById("fire").addEventListener("touchstart", (e) => {
    e.stopPropagation();
    fire();
  });

  document.addEventListener("touchstart", (e) => {
    for (const t of e.changedTouches) {
      if (t.clientX < innerWidth / 2 && !move) {
        move = { id: t.identifier, x: t.clientX, y: t.clientY };
        Object.assign(stick.style, { left: `${t.clientX}px`, top: `${t.clientY}px`, display: "block" });
      } else if (!look) {
        look = { id: t.identifier, x: t.clientX, y: t.clientY };
      }
    }
  });

  document.addEventListener("touchmove", (e) => {
    for (const t of e.changedTouches) {
      if (move?.id === t.identifier) {
        touch.x = Math.max(-1, Math.min(1, (t.clientX - move.x) / JOY_RADIUS));
        touch.y = Math.max(-1, Math.min(1, (t.clientY - move.y) / JOY_RADIUS));
      }
      if (look?.id === t.identifier) {
        camera.rotation.y -= (t.clientX - look.x) / 200;
        camera.rotation.x -= (t.clientY - look.y) / 200;
        look.x = t.clientX;
        look.y = t.clientY;
      }
    }
  });

  const release = (e) => {
    for (const t of e.changedTouches) {
      if (move?.id === t.identifier) {
        move = null;
        touch.x = touch.y = 0;
        stick.style.display = "none";
      }
      if (look?.id === t.identifier) look = null;
    }
  };
  document.addEventListener("touchend", release);
  document.addEventListener("touchcancel", release);

  return touch;
}

export { setupControls };
