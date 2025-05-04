////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/probe.hpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#pragma once

#ifndef NBUNNY_OPTIMAUS_PROBE_HPP
#define NBUNNY_OPTIMAUS_PROBE_HPP

#include <string>
#include <map>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include "nbunny/optimaus/common.hpp"
#include "nbunny/optimaus/scene.hpp"

namespace nbunny
{
    struct ProbeEntity
    {
        std::string interface;
        int id = 0;

        SceneNode* parent_scene_node = nullptr;
        glm::vec3 min = glm::vec3(0.0);
        glm::vec3 max = glm::vec3(0.0);

        glm::vec3 transformed_min;
        glm::vec3 transformed_max;

        bool is_active = false;
    };

    struct ProbeHit
    {
        std::string interface;
        int id;

        glm::vec3 position;
        float distance;
    };

    bool ray_hit_bounds(const glm::vec3& origin, const glm::vec3& direction, const glm::vec3& min, const glm::vec3& max, glm::vec3& point);
    bool cone_hit_bounds(const glm::vec3& cone_position, const glm::vec3& cone_direction, float cone_length, float cone_radius, const glm::vec3& min, const glm::vec3& max, glm::vec3& point);
    bool is_point_in_cone(const glm::vec3& cone_position, const glm::vec3& cone_direction, float cone_length, float cone_radius, const glm::vec3& point, float& distance);
    glm::vec3 project_point_on_line_segment(const glm::vec3& a, const glm::vec3& b, const glm::vec3& point);

	class Probe
	{
	private:
        std::vector<ProbeEntity> entities;
        std::unordered_map<glm::vec3, std::vector<int>> cells;
        std::map<std::pair<std::string, int>, int> entity_indices;
        std::vector<int> free_entity_indices;

        glm::vec3 cell_size;

        bool has_ray = false;
        glm::vec3 ray_origin;
        glm::vec3 ray_direction;

        bool has_cone = false;
        glm::vec3 cone_position;
        glm::vec3 cone_direction;
        float cone_length;
        float cone_radius;

        std::vector<ProbeHit> hits;
        std::unordered_set<int> checked_entities;

        void prepare(float frame_delta);
        void add(ProbeEntity& entity, float frame_delta);

	public:
        Probe(float cell_size);

        void add_or_update(const std::string& interface, int id, SceneNode* parent_scene_node, const glm::vec3& min, const glm::vec3& max);
        void remove(const std::string& interface, int id);
        void reset();
        
        void set_ray(const glm::vec3& origin, const glm::vec3& direction);
        void unset_ray();

        void set_cone(const glm::vec3& position, const glm::vec3& direction, float length, float radius);
        void unset_cone();

        void probe(float frame_delta);

        int get_num_hits() const;
        ProbeHit get_hit(int index) const;
	};
}

#endif
