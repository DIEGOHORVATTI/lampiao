import sys
import bpy
from mathutils import Matrix, Quaternion

args = sys.argv[sys.argv.index("--") + 1:]
source_fbx, target_gltf, output_blend = args[0], args[1], args[2]
only = set(args[3].split(",")) if len(args) > 3 else None

bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.import_scene.fbx(filepath=source_fbx)
source = next(o for o in bpy.data.objects if o.type == "ARMATURE")
source_actions = [a for a in bpy.data.actions]
bpy.ops.import_scene.gltf(filepath=target_gltf)
target = next(o for o in bpy.data.objects if o.type == "ARMATURE" and o != source)
for obj in list(bpy.data.objects):
    if obj.type == "MESH" and obj.parent != target:
        bpy.data.objects.remove(obj)
for action in list(bpy.data.actions):
    if action not in source_actions:
        bpy.data.actions.remove(action)

scene = bpy.context.scene
names = [b.name for b in target.data.bones if b.name in source.data.bones]
order = [b.name for b in target.data.bones if b.name in names]


def rest_world(arm, name):
    return arm.matrix_world @ arm.data.bones[name].matrix_local


source_rest = {n: rest_world(source, n) for n in names}
target_rest = {n: rest_world(target, n) for n in names}
source_rest_rot = {n: source_rest[n].to_quaternion() for n in names}
target_rest_rot = {n: target_rest[n].to_quaternion() for n in names}
height_ratio = target_rest["pelvis"].translation.z / source_rest["pelvis"].translation.z
translated = {"root", "pelvis"}

target.animation_data_create()
source.animation_data_create()
for pb in target.pose.bones:
    pb.rotation_mode = "QUATERNION"

for src_action in source_actions:
    clean = src_action.name.split("|")[-1]
    if only and clean not in only:
        continue
    source.animation_data.action = src_action
    source.animation_data.action_slot = src_action.slots[0]
    start, end = int(src_action.frame_range[0]), int(src_action.frame_range[1])
    frames = list(range(start, end + 1))
    rotations = {n: [] for n in names}
    locations = {n: [] for n in translated}
    for f in frames:
        scene.frame_set(f)
        pose_world = {}
        for n in order:
            src_pose = source.matrix_world @ source.pose.bones[n].matrix
            delta = src_pose.to_quaternion() @ source_rest_rot[n].inverted()
            rot = delta @ target_rest_rot[n]
            bone = target.data.bones[n]
            if n in translated:
                offset = (src_pose.translation - source_rest[n].translation) * height_ratio
                pos = target_rest[n].translation + offset
            else:
                parent = bone.parent.name
                rel = target_rest[parent].inverted() @ target_rest[n]
                pos = (pose_world[parent] @ rel).translation
            world = Matrix.Translation(pos) @ rot.to_matrix().to_4x4()
            pose_world[n] = world
            if bone.parent and bone.parent.name in pose_world:
                parent = bone.parent.name
                rel = target_rest[parent].inverted() @ target_rest[n]
                basis = rel.inverted() @ pose_world[parent].inverted() @ world
            else:
                basis = target_rest[n].inverted() @ world
            q = basis.to_quaternion()
            prev = rotations[n][-1] if rotations[n] else None
            if prev is not None and prev.dot(q) < 0:
                q.negate()
            rotations[n].append(q)
            if n in translated:
                locations[n].append(basis.translation.copy())
    new_action = bpy.data.actions.new(clean)
    new_action.use_fake_user = True
    target.animation_data.action = new_action
    for n in names:
        path = f'pose.bones["{n}"].rotation_quaternion'
        for i in range(4):
            fc = new_action.fcurves.new(path, index=i, action_group=n)
            fc.keyframe_points.add(len(frames))
            data = []
            for f, q in zip(frames, rotations[n]):
                data += [f, q[i]]
            fc.keyframe_points.foreach_set("co", data)
            fc.update()
        if n in translated:
            path = f'pose.bones["{n}"].location'
            for i in range(3):
                fc = new_action.fcurves.new(path, index=i, action_group=n)
                fc.keyframe_points.add(len(frames))
                data = []
                for f, v in zip(frames, locations[n]):
                    data += [f, v[i]]
                fc.keyframe_points.foreach_set("co", data)
                fc.update()
    target.animation_data.action = None
    target.animation_data.action = new_action
    target.animation_data.action_slot = new_action.slots[0]
    print("RETARGETED", clean, len(frames))

target.animation_data.action = None
bpy.data.objects.remove(source)
for action in source_actions:
    bpy.data.actions.remove(action)
for obj in list(bpy.data.objects):
    if obj.type == "MESH":
        bpy.data.objects.remove(obj)
target.name = "Armature"
bpy.ops.wm.save_as_mainfile(filepath=output_blend)
