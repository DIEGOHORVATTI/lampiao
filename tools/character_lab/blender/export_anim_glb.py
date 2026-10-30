import sys
import bpy

args = sys.argv[sys.argv.index("--") + 1:]
anim_blend, output = args[0], args[1]
bpy.ops.wm.open_mainfile(filepath=anim_blend)
arm = bpy.data.objects["Armature"]
mesh = bpy.data.meshes.new("Stub")
head = arm.data.bones["pelvis"].head_local
mesh.from_pydata([tuple(head), tuple(head + head * 0.01), tuple(head + head.yzx * 0.01)], [], [[0, 1, 2]])
stub = bpy.data.objects.new("Stub", mesh)
bpy.context.scene.collection.objects.link(stub)
stub.parent = arm
stub.modifiers.new("Armature", "ARMATURE").object = arm
for bone in arm.data.bones:
    group = stub.vertex_groups.new(name=bone.name)
    group.add([0, 1, 2], 1.0 if bone.name == "pelvis" else 0.0, "REPLACE")
for action in bpy.data.actions:
    arm.animation_data.action = action
    arm.animation_data.action_slot = action.slots[0]
arm.animation_data.action = None
bpy.ops.object.select_all(action="DESELECT")
arm.select_set(True)
stub.select_set(True)
bpy.ops.export_scene.gltf(
    filepath=output,
    export_format="GLB",
    use_selection=True,
    export_materials="NONE",
    export_animations=True,
    export_animation_mode="ACTIONS",
    export_anim_slide_to_zero=True,
    export_optimize_animation_size=True,
    export_yup=True,
    export_skins=True,
)
