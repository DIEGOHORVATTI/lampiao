import sys
import bpy

paths = sys.argv[sys.argv.index("--") + 1:]
for path in paths:
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.gltf(filepath=path)
    print("FILE", path.split("/")[-1])
    for obj in bpy.data.objects:
        if obj.type == "ARMATURE":
            names = [b.name for b in obj.data.bones]
            print("  ARMATURE", obj.name, len(names), names[:6], "...")
        elif obj.type == "MESH":
            tris = sum(len(p.vertices) - 2 for p in obj.data.polygons)
            mats = [m.name for m in obj.data.materials if m]
            groups = len(obj.vertex_groups)
            dims = tuple(round(d, 2) for d in obj.dimensions)
            print("  MESH", obj.name, "tris", tris, "mats", mats, "groups", groups, "dims", dims, "parent", obj.parent.name if obj.parent else None)
