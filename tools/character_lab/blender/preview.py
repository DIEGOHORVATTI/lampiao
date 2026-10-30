import math
import sys
import bpy
from mathutils import Vector

args = sys.argv[sys.argv.index("--") + 1:]
anim_blend, output, poses = args[0], args[1], args[2].split(",")
meshes = args[3:]

bpy.ops.wm.open_mainfile(filepath=anim_blend)
arm = bpy.data.objects["Armature"]
for path in meshes:
    before = set(bpy.data.objects)
    bpy.ops.import_scene.gltf(filepath=path)
    for obj in set(bpy.data.objects) - before:
        if obj.type == "MESH" and obj.parent and obj.parent.type == "ARMATURE":
            obj.parent = arm
            for mod in obj.modifiers:
                if mod.type == "ARMATURE":
                    mod.object = arm
    for obj in set(bpy.data.objects) - before:
        if obj.type != "MESH" or obj.parent != arm:
            bpy.data.objects.remove(obj)

scene = bpy.context.scene
scene.render.engine = "BLENDER_WORKBENCH"
scene.display.shading.light = "STUDIO"
scene.display.shading.color_type = "TEXTURE"
scene.render.resolution_x = 384 * len(poses)
scene.render.resolution_y = 512
scene.render.film_transparent = False
scene.world = bpy.data.worlds.new("w") if not scene.world else scene.world
scene.world.color = (0.3, 0.3, 0.3)

copies = []
for i, pose in enumerate(poses):
    name, frame = (pose.split("@") + ["10"])[:2]
    holder = arm if i == 0 else arm.copy()
    if i:
        holder.data = arm.data
        scene.collection.objects.link(holder)
        for obj in [o for o in bpy.data.objects if o.parent == arm and o.type == "MESH"]:
            dup = obj.copy()
            scene.collection.objects.link(dup)
            dup.parent = holder
            for mod in dup.modifiers:
                if mod.type == "ARMATURE":
                    mod.object = holder
    holder.animation_data_create()
    act = bpy.data.actions[name]
    track = holder.animation_data.nla_tracks.new()
    strip = track.strips.new(act.name, int(act.frame_range[0]) + 1 - int(frame), act)
    strip.action_slot = act.slots[0]
    holder.location = Vector(((i - (len(poses) - 1) / 2) * 1.4, 0, 0))
    copies.append((holder, int(frame)))

cam_data = bpy.data.cameras.new("cam")
cam_data.type = "ORTHO"
cam_data.ortho_scale = max(2.3, 1.45 * len(poses))
cam = bpy.data.objects.new("cam", cam_data)
scene.collection.objects.link(cam)
cam.location = (0, -6, 0.95)
cam.rotation_euler = (math.radians(90), 0, 0)
scene.camera = cam
scene.frame_set(1)
scene.render.filepath = output
bpy.ops.render.render(write_still=True)
