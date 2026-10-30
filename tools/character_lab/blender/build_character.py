import json
import math
import os
import sys

import bmesh
import bpy
import numpy as np
from mathutils import Matrix, Vector

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
import accessories

ASSETS = os.environ.get("LAB_ASSETS", "/tmp/claude-1000/dl/mirror/assets")
ANIMS = os.environ.get("LAB_ANIMS", "/tmp/claude-1000/lab")
ATLAS = 1024
SWATCH = 16

args = sys.argv[sys.argv.index("--") + 1:]
recipe_path, out_dir = args[0], args[1]
recipe = json.load(open(recipe_path))
name = recipe["name"]
os.makedirs(out_dir, exist_ok=True)

bpy.ops.wm.open_mainfile(filepath=os.path.join(ANIMS, f"ual1_{recipe['base']}.blend"))
arm = bpy.data.objects["Armature"]


def import_gltf(path, keep=None):
    before = set(bpy.data.objects)
    bpy.ops.import_scene.gltf(filepath=os.path.join(ASSETS, path))
    new = set(bpy.data.objects) - before
    kept = []
    for obj in new:
        if obj.type == "MESH" and obj.parent and obj.parent.type == "ARMATURE" and (keep is None or obj.name.split(".")[0] in keep):
            matrix = obj.matrix_world.copy()
            obj.parent = arm
            obj.matrix_world = matrix
            for mod in obj.modifiers:
                if mod.type == "ARMATURE":
                    mod.object = arm
            kept.append(obj)
    for obj in new:
        if obj not in kept:
            bpy.data.objects.remove(obj)
    return kept


def weights(obj, vert):
    return {obj.vertex_groups[g.group].name: g.weight for g in vert.groups}


def delete_verts(obj, predicate):
    bm = bmesh.new()
    bm.from_mesh(obj.data)
    deform = bm.verts.layers.deform.active
    names = {g.index: g.name for g in obj.vertex_groups}
    doomed = [v for v in bm.verts if predicate(v.co, {names[i]: w for i, w in v[deform].items()} if deform else {})]
    bmesh.ops.delete(bm, geom=doomed, context="VERTS")
    bm.to_mesh(obj.data)
    bm.free()


def head_bounds(obj):
    pts = [obj.matrix_world @ v.co for v in obj.data.vertices if weights(obj, v).get("Head", 0) > 0.5]
    lo = Vector((min(p.x for p in pts), min(p.y for p in pts), min(p.z for p in pts)))
    hi = Vector((max(p.x for p in pts), max(p.y for p in pts), max(p.z for p in pts)))
    return lo, hi


base_file = f"universal_base_characters/Base Characters/Superhero_{recipe['base']}_FullBody.gltf"
base_meshes = import_gltf(base_file, keep=["SuperHero_Male", "Superhero_Female", "Eyes", "Eyebrows"])
body = next(o for o in base_meshes if o.name.lower().startswith("superhero"))
head_lo, head_hi = head_bounds(body)
neck_keep = recipe.get("neck_keep", 0.5)
delete_verts(body, lambda co, w: w.get("Head", 0) + w.get("neck_01", 0) < neck_keep)
if not recipe.get("eyebrows", True):
    for o in base_meshes:
        if o.name.startswith("Eyebrows"):
            bpy.data.objects.remove(o)
    base_meshes = [o for o in base_meshes if o.name in bpy.data.objects]
eyes = next(o for o in bpy.data.objects if o.name.startswith("Eyes"))
eye_pts = [eyes.matrix_world @ v.co for v in eyes.data.vertices]
eye_r = Vector(np.mean([p for p in eye_pts if p.x < 0], axis=0))
eye_l = Vector(np.mean([p for p in eye_pts if p.x > 0], axis=0))

parts = []
for part in recipe["parts"]:
    parts += import_gltf(part["file"], keep=part.get("meshes"))

hair_objs = []
hair = recipe.get("hair")
if hair:
    hair_objs = import_gltf(f"universal_base_characters/Hairstyles/Rigged/{hair['style']}.gltf")
    if hair.get("fit_from"):
        donor = import_gltf(f"universal_base_characters/Base Characters/Superhero_{hair['fit_from']}_FullBody.gltf", keep=["SuperHero_Male", "Superhero_Female"])[0]
        src_lo, src_hi = head_bounds(donor)
        bpy.data.objects.remove(donor)
        scale = Vector([(head_hi[i] - head_lo[i]) / (src_hi[i] - src_lo[i]) for i in range(3)])
        for obj in hair_objs:
            for v in obj.data.vertices:
                p = obj.matrix_world @ v.co
                q = Vector([head_lo[i] + (p[i] - src_lo[i]) * scale[i] for i in range(3)])
                v.co = obj.matrix_world.inverted() @ q
    cut = head_lo.z + (head_hi.z - head_lo.z) * hair.get("cut", 0.25)
    for obj in hair_objs:
        mw = obj.matrix_world
        groups = {g.name: g for g in obj.vertex_groups}
        for n in ("Head", "neck_01", "spine_03"):
            if n not in groups:
                groups[n] = obj.vertex_groups.new(name=n)
        for v in obj.data.vertices:
            p = mw @ v.co
            if p.z < cut:
                depth = cut - p.z
                if "stretch" in hair:
                    p.z = cut - depth * hair["stretch"]
                    if p.y > head_lo.y + (head_hi.y - head_lo.y) * 0.45:
                        p.y += (cut - p.z) * hair.get("flare", 0.25)
                    spread = hair.get("spread", 0.0)
                    p.x += math.copysign((cut - p.z) * spread, p.x)
                if "clamp" in hair:
                    floor_z = cut - hair["clamp"]
                    p.z = max(p.z, floor_z + (p.z - floor_z) * 0.15) if p.z < floor_z else p.z
                v.co = mw.inverted() @ p
            low = cut - 0.35
            t = min(max((p.z - low) / (cut - low), 0.0), 1.0) if hair.get("stretch") else 1.0
            for g in list(v.groups):
                obj.vertex_groups[g.group].remove([v.index])
            groups["Head"].add([v.index], t, "REPLACE")
            if t < 1.0:
                groups["spine_03"].add([v.index], 1.0 - t, "REPLACE")

rest = {b.name: arm.matrix_world @ b.head_local for b in arm.data.bones}
anchors = {
    "head_lo": head_lo, "head_hi": head_hi, "eye_r": eye_r, "eye_l": eye_l, "bones": rest,
    "tails": {b.name: arm.matrix_world @ b.tail_local for b in arm.data.bones},
}
built = accessories.build(recipe.get("accessories", []), anchors, recipe.get("palette", {}))

palette = dict(accessories.PALETTE)
palette.update(recipe.get("palette", {}))
swatches = {n: i for i, n in enumerate(sorted(palette))}


def material_image(mat):
    if not mat or not mat.use_nodes:
        return None
    for node in mat.node_tree.nodes:
        if node.type == "BSDF_PRINCIPLED":
            link = next(iter(node.inputs["Base Color"].links), None)
            while link and link.from_node.type != "TEX_IMAGE":
                inputs = [i for i in link.from_node.inputs if i.links]
                link = inputs[0].links[0] if inputs else None
            if link:
                return link.from_node.image
    return None


def to_array(image):
    w, h = image.size
    a = np.empty(w * h * 4, dtype=np.float32)
    image.pixels.foreach_get(a)
    return a.reshape(h, w, 4)


def grade(pixels, spec, bounds):
    rgb = pixels[..., :3]
    lum = rgb @ np.array([0.3, 0.59, 0.11], dtype=np.float32)
    lo, hi = bounds
    t = np.clip((lum - lo) / max(hi - lo, 1e-3), 0, 1) ** spec.get("gamma", 1.0)
    stops = [np.array(accessories.color(c, palette), dtype=np.float32) for c in spec["ramp"]]
    seg = t * (len(stops) - 1)
    idx = np.clip(seg.astype(int), 0, len(stops) - 2)
    f = (seg - idx)[..., None]
    ramp = np.stack(stops)
    mapped = ramp[idx] * (1 - f) + ramp[idx + 1] * f
    amount = spec.get("amount", 1.0)
    out = pixels.copy()
    out[..., :3] = rgb * (1 - amount) + mapped * amount
    return out


meshes = base_meshes + parts + hair_objs
for obj in meshes:
    ratio = recipe.get("decimate", {}).get(obj.name.split(".")[0])
    if ratio:
        before = len(obj.data.polygons)
        mod = obj.modifiers.new("Decimate", "DECIMATE")
        mod.ratio = ratio
        mod.use_collapse_triangulate = True
        bpy.ops.object.select_all(action="DESELECT")
        bpy.context.view_layer.objects.active = obj
        bpy.ops.object.modifier_move_to_index(modifier="Decimate", index=0)
        bpy.ops.object.modifier_apply(modifier="Decimate")
        print("DECIMATE", obj.name, before, len(obj.data.polygons))
grades = recipe.get("grades", {})
priority = recipe.get("density", {})
image_cache = {}


def source_pixels(image):
    if image.name not in image_cache:
        image_cache[image.name] = to_array(image)
    return image_cache[image.name]


def find(parent, i):
    while parent[i] != i:
        parent[i] = parent[parent[i]]
        i = parent[i]
    return i


crops = []
seen = {}
for obj in meshes:
    uv = obj.data.uv_layers.active.data
    key = obj.name.split(".")[0]
    for slot_index, slot in enumerate(obj.material_slots):
        faces = [p for p in obj.data.polygons if p.material_index == slot_index]
        if not faces:
            continue
        image = material_image(slot.material)
        mat_key = slot.material.name.split(".")[0]
        spec = grades.get(f"{key}/{mat_key}") or grades.get(mat_key) or grades.get(key)
        for p in faces:
            us = [uv[li].uv[0] for li in p.loop_indices]
            vs = [uv[li].uv[1] for li in p.loop_indices]
            du, dv = math.floor(min(us)), math.floor(min(vs))
            if du or dv:
                for li in p.loop_indices:
                    uv[li].uv = (uv[li].uv[0] - du, uv[li].uv[1] - dv)
        parent = list(range(len(faces)))
        owner = {}
        for fi, p in enumerate(faces):
            for li, vi in zip(p.loop_indices, p.vertices):
                k = (vi, round(uv[li].uv[0], 4), round(uv[li].uv[1], 4))
                if k in owner:
                    ra, rb = find(parent, fi), find(parent, owner[k])
                    if ra != rb:
                        parent[ra] = rb
                else:
                    owner[k] = fi
        islands = {}
        for fi, p in enumerate(faces):
            islands.setdefault(find(parent, fi), []).extend(p.loop_indices)
        src = source_pixels(image)
        h, w = src.shape[:2]
        group_crops = []
        for loops in islands.values():
            us = [uv[li].uv[0] for li in loops]
            vs = [uv[li].uv[1] for li in loops]
            pad = 2
            x0 = max(int(math.floor(min(us) * w)) - pad, 0)
            x1 = min(int(math.ceil(max(us) * w)) + pad, w)
            y0 = max(int(math.floor(min(vs) * h)) - pad, 0)
            y1 = min(int(math.ceil(max(vs) * h)) + pad, h)
            if x1 - x0 < 1 or y1 - y0 < 1:
                continue
            region = (image.name, mat_key, key, x0, y0, x1, y1)
            if region in seen:
                seen[region]["users"].append((obj, loops))
                continue
            seen[region] = {"obj": obj, "key": key, "users": [(obj, loops)], "x0": x0, "y0": y0, "w": x1 - x0, "h": y1 - y0, "src": (w, h), "pixels": src[y0:y1, x0:x1]}
            group_crops.append(seen[region])
        if spec:
            lum = np.concatenate([(c["pixels"][..., :3] @ np.array([0.3, 0.59, 0.11], dtype=np.float32)).ravel() for c in group_crops])
            bounds = (np.percentile(lum, 3), np.percentile(lum, 97))
            for c in group_crops:
                c["pixels"] = grade(c["pixels"], spec, bounds)
        crops += group_crops
        print("GROUP", key, mat_key, image.name, "faces", len(faces), "islands", len(group_crops))


def pack(scale):
    cell = 2
    sky = np.full(ATLAS // cell, SWATCH, dtype=np.int32)
    order = sorted(crops, key=lambda c: -c["h"] * priority.get(c["key"], 1.0))
    placed = {}
    for c in order:
        s = scale * priority.get(c["key"], 1.0)
        cw, ch = max(int(round(c["w"] * s)), 2), max(int(round(c["h"] * s)), 2)
        span = -(-cw // cell)
        if span > len(sky):
            return None
        windows = np.lib.stride_tricks.sliding_window_view(sky, span).max(axis=1)
        col = int(np.argmin(windows))
        top = int(windows[col])
        if top + ch > ATLAS:
            return None
        sky[col:col + span] = top + ch
        placed[id(c)] = (col * cell, top, cw, ch)
    return placed


scale = 1.0
layout = pack(scale)
while layout is None:
    scale *= 0.97
    layout = pack(scale)
print("ATLAS_SCALE", round(scale, 3), "ISLANDS", len(crops))

atlas = np.zeros((ATLAS, ATLAS, 4), dtype=np.float32)
atlas[..., 3] = 1.0
for n, i in swatches.items():
    atlas[0:SWATCH, i * SWATCH:(i + 1) * SWATCH, :3] = accessories.color(n, palette)

for c in crops:
    x, y, cw, ch = layout[id(c)]
    if (cw, ch) == (c["w"], c["h"]):
        atlas[y:y + ch, x:x + cw] = c["pixels"]
    else:
        tmp = bpy.data.images.new("tmp", c["w"], c["h"], alpha=True)
        tmp.pixels.foreach_set(np.ascontiguousarray(c["pixels"]).ravel())
        tmp.scale(cw, ch)
        atlas[y:y + ch, x:x + cw] = to_array(tmp)
        bpy.data.images.remove(tmp)
    sw, sh = c["src"]
    for obj, loops in c["users"]:
        uv = obj.data.uv_layers.active.data
        for li in loops:
            u, v = uv[li].uv
            px = (u * sw - c["x0"]) * (cw / c["w"]) + x
            py = (v * sh - c["y0"]) * (ch / c["h"]) + y
            uv[li].uv = (px / ATLAS, py / ATLAS)

for obj, swatch_of_face in built:
    uv = obj.data.uv_layers.active.data
    for poly, swatch in zip(obj.data.polygons, swatch_of_face):
        i = swatches[swatch]
        for li in poly.loop_indices:
            uv[li].uv = ((i * SWATCH + SWATCH / 2) / ATLAS, (SWATCH / 2) / ATLAS)

atlas_img = bpy.data.images.new(f"{name}_atlas", ATLAS, ATLAS, alpha=True)
atlas_img.pixels.foreach_set(atlas.ravel())
atlas_img.filepath_raw = os.path.join(out_dir, f"{name}_atlas.png")
atlas_img.file_format = "PNG"
atlas_img.save()

material = bpy.data.materials.new(f"M_{name}")
material.use_nodes = True
bsdf = material.node_tree.nodes["Principled BSDF"]
tex = material.node_tree.nodes.new("ShaderNodeTexImage")
tex.image = atlas_img
material.node_tree.links.new(tex.outputs["Color"], bsdf.inputs["Base Color"])
bsdf.inputs["Roughness"].default_value = 1.0

separate = {o.name for o, _ in built if o.get("separate")}
joinable = [o for o in meshes + [o for o, _ in built] if o.name not in separate]
for obj in joinable + [bpy.data.objects[n] for n in separate]:
    obj.data.materials.clear()
    obj.data.materials.append(material)
    for p in obj.data.polygons:
        p.material_index = 0

bpy.ops.object.select_all(action="DESELECT")
for obj in joinable:
    obj.select_set(True)
bpy.context.view_layer.objects.active = joinable[0]
bpy.ops.object.join()
merged = bpy.context.view_layer.objects.active
merged.name = "Body"
merged.data.name = "Body"
for obj in bpy.data.objects:
    if obj.type == "MESH" and obj.parent != arm:
        bpy.data.objects.remove(obj)

tris = 0
for obj in [o for o in bpy.data.objects if o.type == "MESH"]:
    obj.data.calc_loop_triangles()
    tris += len(obj.data.loop_triangles)
    print("MESH", obj.name, len(obj.data.loop_triangles))
print("TRIS", tris)

blend_out = os.path.join(ANIMS, f"{name}.blend")
bpy.ops.wm.save_as_mainfile(filepath=blend_out)

bpy.ops.object.select_all(action="DESELECT")
arm.select_set(True)
for obj in bpy.data.objects:
    if obj.type == "MESH":
        obj.select_set(True)
embed = recipe.get("embed_animations", False)
for action in list(bpy.data.actions):
    if embed:
        arm.animation_data.action = action
        arm.animation_data.action_slot = action.slots[0]
    else:
        bpy.data.actions.remove(action)
arm.animation_data.action = None
bpy.ops.export_scene.gltf(
    filepath=os.path.join(out_dir, f"{name}.glb"),
    export_format="GLB",
    use_selection=True,
    export_materials="PLACEHOLDER",
    export_animations=embed,
    export_animation_mode="ACTIONS",
    export_anim_slide_to_zero=True,
    export_force_sampling=False,
    export_optimize_animation_size=True,
    export_def_bones=False,
    export_yup=True,
    export_apply=False,
    export_skins=True,
    export_morph=False,
)
print("EXPORTED", os.path.join(out_dir, f"{name}.glb"))
