#!/bin/bash
set -e
name=$1
title=$2
base=$3
dir=resources/characters/$name
cat > $dir/${name}_comic.tres <<TRES
[gd_resource type="ShaderMaterial" load_steps=4 format=3]

[ext_resource type="Shader" path="res://resources/characters/shared/comic.gdshader" id="1"]
[ext_resource type="Texture2D" path="res://$dir/${name}_atlas.png" id="2"]
[ext_resource type="Material" path="res://resources/characters/shared/comic_outline.tres" id="3"]

[resource]
next_pass = ExtResource("3")
shader = ExtResource("1")
shader_parameter/albedo_texture = ExtResource("2")
TRES
{
cat <<TSCN
[gd_scene load_steps=4 format=3]

[ext_resource type="PackedScene" path="res://$dir/$name.glb" id="1"]
[ext_resource type="Material" path="res://$dir/${name}_comic.tres" id="2"]
[ext_resource type="AnimationLibrary" path="res://resources/characters/ubc/ual1_$base.res" id="3"]

[node name="$title" instance=ExtResource("1")]
TSCN
i=0
for mesh in "${@:4}"; do
cat <<TSCN

[node name="$mesh" parent="Armature/Skeleton3D" index="$i"]
surface_material_override/0 = ExtResource("2")
TSCN
i=$((i+1))
done
cat <<TSCN

[node name="AnimationPlayer" type="AnimationPlayer" parent="."]
libraries = {
&"": ExtResource("3")
}
TSCN
} > $dir/$name.tscn
sed -i 's/^compress\/mode=.*/compress\/mode=2/; s/^mipmaps\/generate=.*/mipmaps\/generate=true/; s/^detect_3d\/compress_to=.*/detect_3d\/compress_to=0/' $dir/${name}_atlas.png.import
