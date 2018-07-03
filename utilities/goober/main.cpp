////////////////////////////////////////////////////////////////////////////////
// utilities/goober/main.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <cstdio>
#include <cmath>
#include <map>
#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/mesh.h>
#include <assimp/postprocess.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

void exportAnimation(const aiScene* scene, FILE* output)
{
	if (scene->mNumAnimations < 1)
	{
		std::fprintf(stderr, "no animations\n");
		return;
	}

	auto animation = scene->mAnimations[0];
	std::fprintf(output, "{\n");
	for (int i = 0; i < animation->mNumChannels; ++i)
	{
		auto channel = animation->mChannels[i];
		auto node = scene->mRootNode->FindNode(channel->mNodeName);
		std::fprintf(output, "\t[\"%s\"] = {\n", channel->mNodeName.C_Str());

		std::fprintf(output, "\t\ttranslation = {\n");
		for (int j = 0; j < channel->mNumPositionKeys; ++j)
		{
			auto positionKey = &channel->mPositionKeys[j];
			std::fprintf(
				output,
				"\t\t\t{ time = %f, %f, %f, %f },\n",
				positionKey->mTime,
				positionKey->mValue.x,
				positionKey->mValue.y,
				positionKey->mValue.z);
		}
		std::fprintf(output, "\t\t},\n");

		std::fprintf(output, "\t\trotation = {\n");
		for (int j = 0; j < channel->mNumRotationKeys; ++j)
		{
			auto rotationKey = &channel->mRotationKeys[j];
			std::fprintf(
				output,
				"\t\t\t{ time = %f, %f, %f, %f, %f },\n",
				rotationKey->mTime,
				rotationKey->mValue.x,
				rotationKey->mValue.y,
				rotationKey->mValue.z,
				rotationKey->mValue.w);
		}
		std::fprintf(output, "\t\t},\n");

		std::fprintf(output, "\t\tscale = {\n");
		for (int j = 0; j < channel->mNumScalingKeys; ++j)
		{
			auto scaleKey = &channel->mScalingKeys[j];
			std::fprintf(
				output,
				"\t\t\t{ time = %f, %f, %f, %f },\n",
				scaleKey->mTime,
				scaleKey->mValue.x,
				scaleKey->mValue.y,
				scaleKey->mValue.z);
		}
		std::fprintf(output, "\t\t},\n");

		std::fprintf(output, "\t},\n");
	}
	std::fprintf(output, "}\n");
}

void exportBoneNode(
	const aiScene* scene,
	const aiNode* parent,
	const aiNode* node,
	const aiMatrix4x4& matrix,
	FILE* output)
{
	std::fprintf(output, "\t[\"%s\"] = {\n", node->mName.C_Str());
	if (parent)
	{
		std::fprintf(output, "\t\tparent = \"%s\",\n", node->mParent->mName.C_Str());
	}

	aiMatrix4x4 nodeWorldTransform = matrix * node->mTransformation;
	aiMatrix4x4 nodeInverseBindPoseTransform = nodeWorldTransform;
	nodeInverseBindPoseTransform.Inverse();

	auto nodeInverseBindPoseMatrixElements = &nodeInverseBindPoseTransform.a1;
	std::fprintf(output, "\t\tinverseBindPose = { ");
	for (int j = 0; j < 16; ++j)
	{
		std::fprintf(output, "%f, ", nodeInverseBindPoseMatrixElements[j]);
	}
	std::fprintf(output, "},\n");
	std::fprintf(output, "\t},\n");

	for (int i = 0; i < node->mNumChildren; ++i)
	{
		exportBoneNode(scene, node, node->mChildren[i], nodeWorldTransform, output);
	}
}

void exportSkeleton(const aiScene* scene, FILE* output)
{
	if (scene->mNumMeshes < 1)
	{
		std::fprintf(stderr, "no meshes\n");
		return;
	}

	auto node = scene->mRootNode->FindNode("Armature");
	if (!node && node->mParent != scene->mRootNode)
	{
		std::fprintf(stderr, "no skeleton (must be node named 'Armature')\n");
		return;
	}

	std::fprintf(output, "{\n");

	aiMatrix4x4 parent = node->mParent->mTransformation;
	exportBoneNode(scene, nullptr, node, parent, output);

	std::fprintf(output, "}\n");
}

struct Vertex
{
	float position[3] = { 0, 0, 0 };
	float normal[3] = { 0, 1, 0 };
	float texture[2] = { 0, 0 };
	int boneIndex[4] = { -1, -1, -1, -1 };
	float boneWeight[4] = { 0, 0, 0, 0 };
	int bones = 0;
};

void exportMesh(const aiScene* scene, FILE* output)
{
	if (scene->mNumMeshes < 1)
	{
		std::fprintf(stderr, "no meshes\n");
		return;
	}

	auto mesh = scene->mMeshes[0];
	std::fprintf(output, "{\n");
	std::fprintf(output, "\tformat = {\n");
	std::fprintf(output, "\t\t{ 'VertexPosition', 'float', 3 },\n");
	std::fprintf(output, "\t\t{ 'VertexNormal', 'float', 3 },\n");
	std::fprintf(output, "\t\t{ 'VertexTexture', 'float', 2 },\n");
	std::fprintf(output, "\t\t{ 'VertexBoneIndex', 'float', 4 },\n");
	std::fprintf(output, "\t\t{ 'VertexBoneWeight', 'float', 4 },\n");
	std::fprintf(output, "\t},\n");

	std::map<int, Vertex> vertices;
	for (int i = 0; i < mesh->mNumBones; ++i)
	{
		auto bone = mesh->mBones[i];
		for (int j = 0; j < bone->mNumWeights; ++j)
		{
			auto& vertex = vertices[bone->mWeights[j].mVertexId];
			if (vertex.bones < 4)
			{
				vertex.boneIndex[vertex.bones] = i;
				vertex.boneWeight[vertex.bones] = bone->mWeights[j].mWeight;
				++vertex.bones;
			}
		}
	}

	for(auto& i: vertices)
	{
		auto& vertex = i.second;

		float sum = 0.0f;
		for (int j = 0; j < vertex.bones; ++j)
		{
			sum += vertex.boneWeight[j] * vertex.boneWeight[j];
		}

		float length = std::sqrt(sum);
		for (int j = 0; j < vertex.bones; ++j)
		{
			vertex.boneWeight[j] /= length;
		}
	}

	for (int i = 0; i < mesh->mNumVertices; ++i)
	{
		auto& vertex = vertices[i];
		vertex.position[0] = mesh->mVertices[i].x;
		vertex.position[1] = mesh->mVertices[i].y;
		vertex.position[2] = mesh->mVertices[i].z;
		vertex.normal[0] = mesh->mNormals[i].x;
		vertex.normal[1] = mesh->mNormals[i].y;
		vertex.normal[2] = mesh->mNormals[i].z;
		vertex.texture[0] = mesh->mTextureCoords[0][i].x;
		vertex.texture[1] = mesh->mTextureCoords[0][i].y;
	}

	std::fprintf(output, "\tvertices = {\n");
	for (int i = 0; i < mesh->mNumFaces; ++i)
	{
		auto face = mesh->mFaces[i];
		for (int j = 0; j < face.mNumIndices; ++j)
		{
			std::fprintf(output, "\t\t{ ");
			auto& vertex = vertices[face.mIndices[j]];
			std::fprintf(
				output,
				"%f, %f, %f, ",
				vertex.position[0],
				vertex.position[1],
				vertex.position[2]);
			std::fprintf(
				output,
				"%f, %f, %f, ",
				vertex.normal[0],
				vertex.normal[1],
				vertex.normal[2]);
			std::fprintf(
				output,
				"%f, %f, ",
				vertex.texture[0],
				vertex.texture[1]);
			for (int j = 0; j < 4; ++j)
			{
				if (vertex.boneIndex[j] < 0)
				{
					std::fprintf(output, "false, ");
				}
				else
				{
					auto bone = mesh->mBones[vertex.boneIndex[j]];
					std::fprintf(output, "\"%s\", ", bone->mName.C_Str());
				}
			}

			std::fprintf(
				output,
				"%f, %f, %f, %f, ",
				vertex.boneWeight[0],
				vertex.boneWeight[1],
				vertex.boneWeight[2],
				vertex.boneWeight[3]);
			std::fprintf(output, "},\n");
		}
	}
	std::fprintf(output, "\t},\n");

	std::fprintf(output, "}\n");
}

void exportStaticMesh(const aiScene* scene, const aiMesh* mesh, FILE* output)
{
	std::fprintf(output, "\t{\n");
	std::fprintf(output, "\t\tname = \"%s\",\n", mesh->mName.C_Str());

	for (int i = 0; i < mesh->mNumFaces; ++i)
	{
		auto face = mesh->mFaces[i];
		for (int j = 0; j < face.mNumIndices; ++j)
		{
			std::fprintf(output, "\t\t{ ");
			auto index = face.mIndices[j];
			auto& position = mesh->mVertices[index];
			auto& normal = mesh->mNormals[index];
			auto& texture = mesh->mTextureCoords[0][index];
			std::fprintf(
				output,
				"%f, %f, %f, ",
				position.x,
				position.y,
				position.z);
			std::fprintf(
				output,
				"%f, %f, %f, ",
				normal.x,
				normal.y,
				normal.z);
			std::fprintf(
				output,
				"%f, %f, ",
				texture.x,
				texture.y);
			std::fprintf(output, "},\n");
		}
	}
	std::fprintf(output, "\t},\n");
}

void exportStaticMeshes(const aiScene* scene, FILE* output)
{
	if (scene->mNumMeshes < 1)
	{
		std::fprintf(stderr, "no meshes\n");
		return;
	}

	std::fprintf(output, "{\n");
	std::fprintf(output, "\tformat =\n");
	std::fprintf(output, "\t{\n");
	std::fprintf(output, "\t\t{ 'VertexPosition', 'float', 3 },\n");
	std::fprintf(output, "\t\t{ 'VertexNormal', 'float', 3 },\n");
	std::fprintf(output, "\t\t{ 'VertexTexture', 'float', 2 },\n");
	std::fprintf(output, "\t},\n");

	for (int i = 0; i < scene->mNumMeshes; ++i)
	{
		exportStaticMesh(scene, scene->mMeshes[i], output);
	}

	std::fprintf(output, "}\n");
}

int main(int argc, const char* argv[])
{
	if (argc < 4)
	{
		std::fprintf(stderr, "%s <mesh/skeleton/animation> <filename> <output>\n", argv[0]);
		return 1;
	}

	Assimp::Importer importer;
	auto scene = importer.ReadFile(argv[2], aiProcess_Triangulate);
	if (!scene)
	{
		std::fprintf(stderr, "couldn't load %s\n", argv[2]);
		return 1;
	}

	FILE* output = std::fopen(argv[3], "w");
	if (!output)
	{
		std::fprintf(stderr, "couldn't open %s for writing\n", argv[3]);
		return 1;
	}

	if (std::strcmp(argv[1], "mesh") == 0)
	{
		exportMesh(scene, output);
	}
	else if (std::strcmp(argv[1], "skeleton") == 0)
	{
		exportSkeleton(scene, output);
	}
	else if (std::strcmp(argv[1], "animation") == 0)
	{
		exportAnimation(scene, output);
	}
	else if (std::strcmp(argv[1], "static") == 0)
	{
		exportStaticMeshes(scene, output);
	}
	else
	{
		std::fprintf(stderr, "unknown action %s; must be either mesh, skeleton, animation, or static\n", argv[1]);
		return 1;
	}

	std::fclose(output);

	return 0;
}
