import math

import bmesh
import bpy
from mathutils import Matrix, Vector

PALETTE = {
    "ink": (0.05, 0.04, 0.04),
    "sepia_dark": (0.17, 0.11, 0.08),
    "leather": (0.36, 0.21, 0.12),
    "leather_light": (0.52, 0.33, 0.19),
    "coat": (0.33, 0.23, 0.15),
    "ochre": (0.80, 0.60, 0.30),
    "cream": (0.93, 0.86, 0.70),
    "mustard": (0.86, 0.64, 0.16),
    "brass": (0.74, 0.56, 0.24),
    "khaki": (0.62, 0.55, 0.40),
    "khaki_dark": (0.36, 0.31, 0.22),
    "white": (0.95, 0.93, 0.88),
    "wood": (0.42, 0.23, 0.12),
    "metal": (0.16, 0.16, 0.17),
    "red": (0.55, 0.12, 0.08),
}


def color(name, palette):
    value = palette.get(name, PALETTE.get(name))
    return tuple(value[:3])


class Builder:
    def __init__(self):
        self.verts = []
        self.weights = []
        self.faces = []
        self.swatches = []

    def add(self, points, faces, swatch, weight):
        base = len(self.verts)
        for p in points:
            self.verts.append(Vector(p))
            self.weights.append(weight(Vector(p)) if callable(weight) else weight)
        for f in faces:
            self.faces.append([base + i for i in f])
            self.swatches.append(swatch)

    def ring_mesh(self, rings, swatch, weight, closed=True, cap=False):
        n = len(rings[0])
        faces = []
        for r in range(len(rings) - 1):
            for i in range(n if closed else n - 1):
                j = (i + 1) % n
                faces.append([r * n + i, r * n + j, (r + 1) * n + j, (r + 1) * n + i])
        points = [p for ring in rings for p in ring]
        if cap:
            faces.append(list(range(n))[::-1])
            last = (len(rings) - 1) * n
            faces.append([last + i for i in range(n)])
        self.add(points, faces, swatch, weight)

    def tube(self, path, radius, swatch, weight, sides=6, closed=False, flat=1.0, up=Vector((0, 0, 1))):
        rings = []
        count = len(path)
        for k, p in enumerate(path):
            a = path[(k - 1) % count] if closed or k > 0 else path[k]
            b = path[(k + 1) % count] if closed or k < count - 1 else path[k]
            t = (Vector(b) - Vector(a)).normalized()
            side = t.cross(up)
            if side.length < 1e-4:
                side = t.cross(Vector((0, 1, 0)))
            side.normalize()
            nrm = side.cross(t).normalized()
            r = radius(k / max(count - 1, 1)) if callable(radius) else radius
            rings.append([Vector(p) + (side * math.cos(a2) * flat + nrm * math.sin(a2)) * r for a2 in [2 * math.pi * s / sides for s in range(sides)]])
        if closed:
            rings.append(rings[0])
        self.ring_mesh(rings, swatch, weight, cap=not closed)

    def cylinder(self, center, axis, radius, length, swatch, weight, sides=10, radius_top=None):
        axis = Vector(axis).normalized()
        ref = Vector((1, 0, 0)) if abs(axis.x) < 0.9 else Vector((0, 1, 0))
        u = axis.cross(ref).normalized()
        v = axis.cross(u).normalized()
        c = Vector(center)
        rt = radius if radius_top is None else radius_top
        bottom = [c - axis * length / 2 + (u * math.cos(t) + v * math.sin(t)) * radius for t in [2 * math.pi * s / sides for s in range(sides)]]
        top = [c + axis * length / 2 + (u * math.cos(t) + v * math.sin(t)) * rt for t in [2 * math.pi * s / sides for s in range(sides)]]
        self.ring_mesh([bottom, top], swatch, weight, cap=True)

    def ellipsoid(self, center, radii, swatch, weight, rings=6, sides=10, z_min=-1.0, matrix=None):
        c = Vector(center)
        rows = []
        for r in range(rings + 1):
            phi = math.asin(z_min) + (math.pi / 2 - math.asin(z_min)) * r / rings
            row = []
            for s in range(sides):
                th = 2 * math.pi * s / sides
                local = Vector((math.cos(phi) * math.cos(th) * radii[0], math.cos(phi) * math.sin(th) * radii[1], math.sin(phi) * radii[2]))
                if matrix:
                    local = matrix @ local
                row.append(c + local)
            rows.append(row)
        self.ring_mesh(rows, swatch, weight, cap=True)

    def box(self, center, size, swatch, weight, matrix=None):
        hx, hy, hz = size[0] / 2, size[1] / 2, size[2] / 2
        local = [(-hx, -hy, -hz), (hx, -hy, -hz), (hx, hy, -hz), (-hx, hy, -hz), (-hx, -hy, hz), (hx, -hy, hz), (hx, hy, hz), (-hx, hy, hz)]
        m = matrix or Matrix.Identity(3)
        points = [Vector(center) + m @ Vector(p) for p in local]
        faces = [[0, 3, 2, 1], [4, 5, 6, 7], [0, 1, 5, 4], [1, 2, 6, 5], [2, 3, 7, 6], [3, 0, 4, 7]]
        self.add(points, faces, swatch, weight)

    def slab(self, outline, frame, thickness, swatch, weight):
        n = len(outline)
        front = [frame(u, v, -thickness / 2) for u, v in outline]
        back = [frame(u, v, thickness / 2) for u, v in outline]
        faces = [list(range(n)), list(range(2 * n - 1, n - 1, -1))]
        for i in range(n):
            j = (i + 1) % n
            faces.append([i, n + i, n + j, j])
        self.add(front + back, faces, swatch, weight)

    def to_object(self, name, arm):
        mesh = bpy.data.meshes.new(name)
        mesh.from_pydata([tuple(v) for v in self.verts], [], self.faces)
        bm = bmesh.new()
        bm.from_mesh(mesh)
        bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
        bm.to_mesh(mesh)
        bm.free()
        mesh.update()
        obj = bpy.data.objects.new(name, mesh)
        bpy.context.scene.collection.objects.link(obj)
        obj.parent = arm
        mod = obj.modifiers.new("Armature", "ARMATURE")
        mod.object = arm
        groups = {}
        for i, w in enumerate(self.weights):
            for bone, value in w.items():
                if bone not in groups:
                    groups[bone] = obj.vertex_groups.new(name=bone)
                groups[bone].add([i], value, "REPLACE")
        mesh.uv_layers.new(name="UVMap")
        for poly in mesh.polygons:
            poly.use_smooth = False
        return obj, list(self.swatches)


def blend(a, b, za, zb):
    def weight(p):
        t = min(max((p.z - zb) / (za - zb), 0.0), 1.0)
        out = {}
        if t > 0:
            out[a] = t
        if t < 1:
            out[b] = out.get(b, 0) + 1 - t
        return out
    return weight


def head_frame(a):
    lo, hi = a["head_lo"], a["head_hi"]
    center = (lo + hi) / 2
    return lo, hi, center


def hat_crescent(b, a, spec, pal):
    lo, hi, c = head_frame(a)
    width = (hi.x - lo.x)
    depth = (hi.y - lo.y)
    w = {"Head": 1.0}
    top = hi.z
    brow = a["eye_r"].z + (top - a["eye_r"].z) * spec.get("brow", 0.35)
    crown_c = Vector((c.x, c.y + depth * 0.05, brow))
    b.ellipsoid(crown_c, (width * 0.56, depth * 0.56, (top - brow) + 0.025), spec.get("crown", "leather"), w, rings=5, sides=14, z_min=0.0)
    span = width * spec.get("span", 1.25)
    rise = spec.get("rise", 0.13)
    lean = spec.get("lean", 0.45)
    y_front = lo.y + depth * 0.18
    bend = spec.get("bend", 2.2)

    def front(u, v, t):
        return Vector((c.x + u, y_front + bend * u * u + v * lean + t, brow + v))

    def back(u, v, t):
        return Vector((c.x + u, hi.y - depth * 0.1 - bend * u * u * 0.6 - v * lean - t, brow + v))

    steps = 14
    outer = [(span * math.cos(math.pi * k / steps), rise * math.sin(math.pi * k / steps) + 0.0) for k in range(steps + 1)]
    inner = [(span * 0.82 * math.cos(math.pi * k / steps), rise * 0.3 * math.sin(math.pi * k / steps) - 0.012) for k in range(steps, -1, -1)]
    outline = outer + inner
    b.slab(outline, front, 0.012, spec.get("flap", "leather"), w)
    b.slab([(u * 0.85, v * 0.8) for u, v in outline], back, 0.012, spec.get("flap", "leather"), w)
    edge = [front(span * 0.99 * math.cos(math.pi * k / steps), rise * 0.99 * math.sin(math.pi * k / steps), -0.007) for k in range(steps + 1)]
    b.tube(edge, 0.005, spec.get("edge", "sepia_dark"), w, sides=4)
    style = spec.get("emblem", "medallion")
    spots = [(-span * 0.45, rise * 0.42), (0.0, rise * 0.6), (span * 0.45, rise * 0.42)]
    for u, v in spots:
        p = front(u, v, -0.008)
        normal = Vector((-2 * bend * u, -1, 0)).normalized()
        if style == "medallion":
            b.cylinder(p, normal, 0.034, 0.006, "sepia_dark", w, sides=14)
            b.cylinder(p + normal * 0.004, normal, 0.028, 0.006, spec.get("medal", "ochre"), w, sides=14)
            side = normal.cross(Vector((0, 0, 1))).normalized()
            upv = side.cross(normal).normalized()
            for k in range(4):
                ang = k * math.pi / 2
                d = side * math.cos(ang) + upv * math.sin(ang)
                m = Matrix((d, d.cross(normal).normalized(), normal)).transposed()
                b.ellipsoid(p + normal * 0.008 + d * 0.012, (0.013, 0.005, 0.002), spec.get("petal", "cream"), w, rings=2, sides=6, matrix=m)
        else:
            side = normal.cross(Vector((0, 0, 1))).normalized()
            upv = side.cross(normal).normalized()
            m = Matrix((side, upv, normal)).transposed() @ Matrix.Rotation(math.pi / 4, 3, "Z")
            b.box(p, (0.042, 0.042, 0.006), "sepia_dark", w, matrix=m)
            b.box(p + normal * 0.003, (0.034, 0.034, 0.006), spec.get("medal", "cream"), w, matrix=m)
            b.box(p + normal * 0.006, (0.036, 0.004, 0.004), "sepia_dark", w, matrix=Matrix((side, upv, normal)).transposed())
            b.box(p + normal * 0.006, (0.004, 0.036, 0.004), "sepia_dark", w, matrix=Matrix((side, upv, normal)).transposed())
    for sgn in (-1, 1):
        tip = front(sgn * span * 0.97, 0.0, 0.0)
        for k in range(spec.get("tassels", 3)):
            off = Vector((sgn * 0.006 * k, 0.004 * k, 0))
            b.cylinder(tip + off - Vector((0, 0, 0.045)), (0, 0, 1), 0.004, 0.08, spec.get("tassel", "leather_light"), w, sides=4)


def glasses(b, a, spec, pal):
    w = {"Head": 1.0}
    lo, hi, c = head_frame(a)
    r = spec.get("radius", 0.019)
    lenses = []
    for eye in (a["eye_r"], a["eye_l"]):
        center = Vector((eye.x * 1.05, lo.y - 0.004, eye.z))
        ring = [center + Vector((math.cos(t) * r, 0, math.sin(t) * r)) for t in [2 * math.pi * k / 14 for k in range(14)]]
        b.tube(ring, 0.0022, "ink", w, sides=4, closed=True, up=Vector((0, 1, 0)))
        lenses.append(center)
    b.tube([lenses[0] + Vector((r, 0, 0.003)), (lenses[0] + lenses[1]) / 2 + Vector((0, -0.002, 0.006)), lenses[1] - Vector((r, 0, -0.003))], 0.0018, "ink", w, sides=4)
    for k, center in enumerate(lenses):
        sgn = -1 if k == 0 else 1
        start = center + Vector((sgn * r, 0, 0))
        ear = Vector((c.x + sgn * (hi.x - lo.x) * 0.48, c.y + 0.01, center.z + 0.004))
        b.tube([start, ear], 0.0018, "ink", w, sides=4)
    if spec.get("blind_right", False):
        b.cylinder(lenses[0] + Vector((0, -0.001, 0)), (0, 1, 0), r * 0.95, 0.002, "white", w, sides=14)


def neck_ring(a, rise):
    n = a["bones"]["neck_01"]
    h = a["bones"]["Head"]
    return n + (h - n) * rise


def choker(b, a, spec, pal):
    lo, hi, c = head_frame(a)
    center = neck_ring(a, spec.get("rise", 0.55))
    rx, ry = (hi.x - lo.x) * 0.33, (hi.y - lo.y) * 0.36
    ring = [Vector((center.x + math.cos(t) * rx, c.y + math.sin(t) * ry, center.z)) for t in [2 * math.pi * k / 16 for k in range(16)]]
    b.tube(ring, 0.009, "ink", {"neck_01": 1.0}, sides=4, closed=True, flat=0.6)
    b.ellipsoid(Vector((center.x, c.y - ry - 0.008, center.z)), (0.007, 0.004, 0.006), "white", {"neck_01": 1.0}, rings=3, sides=6)


def scarf(b, a, spec, pal):
    lo, hi, c = head_frame(a)
    sw = spec.get("color", "mustard")
    base = a["bones"]["neck_01"]
    chest = a["bones"]["spine_03"]
    rx, ry = (hi.x - lo.x) * 0.58, (hi.y - lo.y) * 0.52
    ring = [Vector((base.x + math.cos(t) * rx, c.y + 0.01 + math.sin(t) * ry, base.z + 0.0 - 0.025 * math.sin(t))) for t in [2 * math.pi * k / 16 for k in range(16)]]
    b.tube(ring, 0.024, sw, {"neck_01": 0.5, "spine_03": 0.5}, sides=6, closed=True, flat=0.6)
    front_y = c.y - ry - 0.005
    width = spec.get("width", 0.13)
    drop = spec.get("drop", 0.17)
    top_z = base.z + 0.0

    def bib(u, v, t):
        return Vector((base.x + u, front_y + 0.06 * (u * u / (width * width)) + t - 0.02 * (v / drop), top_z + v))

    b.slab([(-width, 0.0), (0.0, -drop), (width, 0.0)], bib, 0.012, sw, {"spine_03": 1.0})
    knot = Vector((base.x, front_y - 0.022, top_z - 0.035))
    b.ellipsoid(knot, (0.04, 0.03, 0.035), sw, {"spine_03": 1.0}, rings=4, sides=8)
    length = spec.get("length", 0.12)
    for sgn in (-1, 1):
        top = knot + Vector((sgn * 0.02, -0.01, -0.01))
        path = [top + Vector((sgn * 0.045 * t, -0.02 * t, -length * t)) for t in (0.0, 0.5, 1.0)]
        b.tube(path, lambda t: 0.04 * (1 - 0.7 * t), sw, {"spine_03": 1.0}, sides=4, flat=0.3, up=Vector((0, 1, 0)))


def torso_loop(a, z_center, tilt, rx, ry, steps=20):
    return [Vector((math.cos(t) * rx, a["bones"]["spine_02"].y + math.sin(t) * ry, z_center + math.tan(tilt) * math.cos(t) * rx)) for t in [2 * math.pi * k / steps for k in range(steps)]]


def bandolier(b, a, spec, pal):
    tilt = math.radians(spec.get("tilt", 38))
    chest = a["bones"]["spine_03"]
    pelvis = a["bones"]["pelvis"]
    zc = spec.get("z", (chest.z + pelvis.z) / 2 + 0.06)
    rx, ry = spec.get("rx", 0.2), spec.get("ry", 0.15)
    weight = blend("spine_03", "pelvis", chest.z + 0.1, pelvis.z)
    for sgn in spec.get("sides", (1, -1)):
        path = torso_loop(a, zc, sgn * tilt, rx, ry, steps=24)
        b.tube(path, 0.022, spec.get("strap", "leather"), weight, sides=4, closed=True, flat=0.25, up=Vector((0, 0, 1)))
        for k, p in enumerate(path):
            if p.y < a["bones"]["spine_02"].y - ry * 0.3 and k % 1 == 0:
                out = Vector((p.x, p.y - a["bones"]["spine_02"].y, 0)).normalized()
                along = (path[(k + 1) % len(path)] - path[k - 1]).normalized()
                for off in (-0.012, 0.012):
                    q = p + along * off + out * 0.012
                    b.cylinder(q, along.cross(out).normalized(), 0.0055, 0.04, spec.get("bullet", "brass"), weight, sides=5)


def belt(b, a, spec, pal):
    pelvis = a["bones"]["pelvis"]
    z = pelvis.z + spec.get("dz", 0.06)
    rx, ry = spec.get("rx", 0.17), spec.get("ry", 0.13)
    path = [Vector((math.cos(t) * rx, pelvis.y + math.sin(t) * ry, z)) for t in [2 * math.pi * k / 20 for k in range(20)]]
    w = {"pelvis": 1.0}
    b.tube(path, spec.get("width", 0.03), spec.get("color", "leather"), w, sides=4, closed=True, flat=0.3)
    if spec.get("bullets"):
        for k, p in enumerate(path):
            if p.y < pelvis.y:
                out = Vector((p.x, p.y - pelvis.y, 0)).normalized()
                b.cylinder(p + out * 0.012, (0, 0, 1), 0.006, 0.042, "brass", w, sides=5)
    if spec.get("buckle"):
        b.box(Vector((0, pelvis.y - ry - 0.008, z)), (0.05, 0.01, 0.04), "brass", w)
    if spec.get("knife"):
        p = Vector((rx * 0.75, pelvis.y - ry * 0.6, z))
        b.box(p + Vector((0, -0.01, 0.03)), (0.03, 0.025, 0.1), "wood", w)
        b.box(p + Vector((0, -0.01, -0.12)), (0.04, 0.015, 0.26), "leather", w)
    if spec.get("sash"):
        for sgn, length in ((1, 0.22), (1, 0.17)):
            top = Vector((sgn * rx * 0.7, pelvis.y - ry * 0.7, z - 0.02))
            b.tube([top, top + Vector((0.01, -0.02, -length))], lambda t: 0.025 * (1 - 0.5 * t), spec["sash"], {"pelvis": 1.0}, sides=4, flat=0.3, up=Vector((0, 1, 0)))


def coat_tails(b, a, spec, pal):
    pelvis = a["bones"]["pelvis"]
    knee = (a["bones"]["calf_l"].z + a["bones"]["calf_r"].z) / 2
    top_z = pelvis.z + spec.get("top", 0.04)
    bottom_z = knee + spec.get("below_knee", -0.05)
    gap = math.radians(spec.get("gap", 50))
    rows = []
    levels = 5
    for r in range(levels):
        t = r / (levels - 1)
        z = top_z + (bottom_z - top_z) * t
        rx = spec.get("rx", 0.18) + spec.get("flare", 0.06) * t
        ry = spec.get("ry", 0.14) + spec.get("flare", 0.06) * t * 0.8
        row = []
        steps = 16
        for k in range(steps + 1):
            ang = -math.pi / 2 + gap + (2 * math.pi - 2 * gap) * k / steps
            row.append(Vector((math.cos(ang) * rx, pelvis.y + math.sin(ang) * ry + 0.01, z)))
        rows.append(row)

    def weight(p):
        t = min(max((top_z - p.z) / (top_z - bottom_z), 0.0), 1.0) * 0.8
        side = "thigh_l" if p.x > 0 else "thigh_r"
        lateral = min(abs(p.x) / 0.12, 1.0)
        out = {"pelvis": 1 - t * lateral}
        if t * lateral > 0:
            out[side] = t * lateral
        return out
    flipped = [list(reversed(r)) for r in rows]
    b.ring_mesh(rows, spec.get("color", "coat"), weight, closed=False)
    inner = [[p + (Vector((p.x, p.y - pelvis.y, 0)).normalized() * -0.004) for p in r] for r in flipped]
    b.ring_mesh(inner, spec.get("color", "coat"), weight, closed=False)


def quepe(b, a, spec, pal):
    lo, hi, c = head_frame(a)
    w = {"Head": 1.0}
    width = hi.x - lo.x
    depth = hi.y - lo.y
    base_z = a["eye_r"].z + (hi.z - a["eye_r"].z) * spec.get("brow", 0.55)
    height = spec.get("height", 0.085)
    rows = []
    for r, (z, s) in enumerate([(0, 1.0), (height * 0.6, 1.04), (height, spec.get("top_scale", 1.12))]):
        rows.append([Vector((c.x + math.cos(t) * width * 0.56 * s, c.y + 0.004 + math.sin(t) * depth * 0.56 * s, base_z + z + (0.012 * math.sin(t) if r else 0))) for t in [2 * math.pi * k / 16 for k in range(16)]])
    b.ring_mesh(rows, spec.get("color", "khaki"), w, cap=True)
    band = [Vector((p.x, p.y, base_z + 0.012)) for p in rows[0]]
    b.tube(band + [band[0]], 0.012, spec.get("band", "sepia_dark"), w, sides=4, flat=0.25)
    visor = []
    for k in range(9):
        t = math.pi + math.pi * k / 8
        visor.append((math.cos(t) * width * 0.5, math.sin(t) * depth * 0.38))
    visor = [(u, v) for u, v in visor] + [(u * 0.98, -0.005) for u, v in reversed(visor)]

    def frame(u, v, t):
        return Vector((c.x + u, lo.y + depth * 0.12 + v, base_z + t - 0.006 - abs(v) * 0.3))

    b.slab(visor, frame, 0.006, spec.get("visor", "ink"), w)
    b.cylinder(Vector((c.x, lo.y + depth * 0.02, base_z + height * 0.55)), (0, 1, 0), 0.012, 0.006, spec.get("badge", "brass"), w, sides=8)


def rifle_shape(b, origin, forward, up, weight, scale=1.0):
    f = Vector(forward).normalized()
    u = Vector(up).normalized()
    s = f.cross(u).normalized()
    m = Matrix((s, f, u)).transposed()
    o = Vector(origin)
    b.box(o + f * -0.33 * scale, (0.035, 0.22, 0.06), "wood", weight, matrix=m)
    b.box(o + f * 0.0, (0.032, 0.48, 0.035), "wood", weight, matrix=m)
    b.box(o + f * 0.02 + u * 0.022, (0.026, 0.18, 0.02), "metal", weight, matrix=m)
    b.cylinder(o + f * 0.36 + u * 0.012, f, 0.008, 0.5, "metal", weight, sides=6)
    b.cylinder(o + f * 0.05 + u * 0.03 + s * 0.025, s, 0.004, 0.04, "metal", weight, sides=4)


def rifle_back(b, a, spec, pal):
    chest = a["bones"]["spine_03"]
    origin = Vector((0.0, chest.y + 0.17, chest.z - 0.08))
    ang = math.radians(spec.get("angle", 55))
    forward = Vector((math.cos(ang), 0, math.sin(ang)))
    rifle_shape(b, origin, forward, (0, 1, 0), {"spine_03": 1.0})


def rifle_hand(b, a, spec, pal):
    hand = a["bones"]["hand_r"]
    tail = a["tails"]["hand_r"]
    palm = hand + (tail - hand) * 0.9 + Vector((0, 0, -0.02))
    rifle_shape(b, palm + Vector((0, -0.12, 0)), (0, -1, 0), (0, 0, 1), {"hand_r": 1.0})


def rosary(b, a, spec, pal):
    hand = a["bones"]["hand_r"]
    tail = a["tails"]["hand_r"]
    grip = hand + (tail - hand) * 0.8
    w = {"hand_r": 1.0}
    beads = 18
    for k in range(beads):
        t = k / (beads - 1)
        ang = math.pi * t
        p = grip + Vector((0.04 * math.sin(ang * 2) * 0.3, -0.02 * math.sin(ang), -0.13 * math.sin(ang)))
        b.ellipsoid(p, (0.006, 0.006, 0.006), "ink", w, rings=2, sides=5)
    end = grip + Vector((0, -0.01, -0.15))
    b.box(end + Vector((0, 0, -0.03)), (0.008, 0.008, 0.06), "brass", w)
    b.box(end + Vector((0, 0, -0.015)), (0.035, 0.008, 0.008), "brass", w)


BUILDERS = {
    "hat_crescent": hat_crescent,
    "glasses": glasses,
    "choker": choker,
    "scarf": scarf,
    "bandolier": bandolier,
    "belt": belt,
    "coat_tails": coat_tails,
    "quepe": quepe,
    "rifle_back": rifle_back,
    "rifle_hand": rifle_hand,
    "rosary": rosary,
}


def build(specs, anchors, palette):
    arm = bpy.data.objects["Armature"]
    shared = Builder()
    out = []
    for spec in specs:
        if spec.get("separate"):
            b = Builder()
            BUILDERS[spec["type"]](b, anchors, spec, palette)
            obj, sw = b.to_object(spec["separate"], arm)
            obj["separate"] = True
            out.append((obj, sw))
        else:
            BUILDERS[spec["type"]](shared, anchors, spec, palette)
    if shared.verts:
        out.append(shared.to_object("Accessories", arm))
    return out
