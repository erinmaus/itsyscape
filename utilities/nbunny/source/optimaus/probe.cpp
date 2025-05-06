////////////////////////////////////////////////////////////////////////////////
// nbunny/optimaus/probe.cpp
//
// This file is a part of ItsyScape.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
////////////////////////////////////////////////////////////////////////////////

#include <limits>
#include "nbunny/optimaus/probe.hpp"

bool nbunny::ray_hit_bounds(const glm::vec3& origin, const glm::vec3& direction, const glm::vec3& min, const glm::vec3& max, glm::vec3& point)
{
	// 1: https://tavianator.com/fast-branchless-raybounding-box-intersections/
	// 2: https://tavianator.com/2015/ray_box_nan.html
    float t_min, t_max;

    float tx1 = (min.x - origin.x) / direction.x;
    float tx2 = (max.x - origin.x) / direction.x;

    t_min = std::min(tx1, tx2);
    t_max = std::max(tx1, tx2);

    float ty1 = (min.y - origin.y) / direction.y;
    float ty2 = (max.y - origin.y) / direction.y;

    t_min = std::max(t_min, std::min(std::min(ty1, ty2), t_max));
    t_max = std::min(t_max, std::max(std::max(ty1, ty2), t_min));

    float tz1 = (min.z - origin.z) / direction.z;
    float tz2 = (max.z - origin.z) / direction.z;

    t_min = std::max(t_min, std::min(std::min(tz1, tz2), t_max));
    t_max = std::min(t_max, std::max(std::max(tz1, tz2), t_min));

    if (t_max > t_min && t_min >= 0)
    {
        point = origin + direction * glm::vec3(t_min);
        return true;
    }
    else
    {
        return false;
    }
}


glm::vec3 nbunny::project_point_on_line_segment(const glm::vec3& a, const glm::vec3& b, const glm::vec3& p)
{
    auto length = glm::length(a - b);
    if (length == 0.0f)
    {
        return a;
    }

    auto p_minus_a = p - a;
    auto b_minus_a = b - a;
    auto t = glm::clamp(glm::dot(p_minus_a, b_minus_a) / (length * length), 0.0f, 1.0f);

    return a + b_minus_a * glm::vec3(t);
}

bool nbunny::is_point_in_cone(const glm::vec3& cone_position, const glm::vec3& cone_direction, float cone_length, float cone_radius, const glm::vec3& point, float& distance)
{
    auto difference = point - cone_position;
    auto cone_distance = glm::dot(difference, cone_direction);
    auto delta = cone_distance / cone_length;
    auto radius = delta * cone_radius;
    auto orthogonal_distance = glm::length(difference - cone_direction * glm::vec3(cone_distance));

    if (orthogonal_distance < radius)
    {
        distance = orthogonal_distance;
        return true;
    }

    return false;
}

bool nbunny::cone_hit_bounds(const glm::vec3& cone_position, const glm::vec3& cone_direction, float cone_length, float cone_radius, const glm::vec3& min, const glm::vec3& max, glm::vec3& point)
{
    auto fbl = glm::vec3(min.x, min.y, max.z);
    auto fbr = glm::vec3(max.x, min.y, max.z);
    auto bbl = glm::vec3(min.x, min.y, min.z);
    auto bbr = glm::vec3(max.x, min.y, min.z);
    auto ftl = glm::vec3(min.x, max.y, max.z);
    auto ftr = glm::vec3(max.x, max.y, max.z);
    auto btl = glm::vec3(min.x, max.y, min.z);
    auto btr = glm::vec3(max.x, max.y, min.z);

    const std::vector<glm::vec3> points = {
        // Bottom
        project_point_on_line_segment(fbl, fbr, cone_position),
        project_point_on_line_segment(fbr, bbr, cone_position),
        project_point_on_line_segment(bbr, bbl, cone_position),
        project_point_on_line_segment(bbl, fbl, cone_position),

        // Top
        project_point_on_line_segment(ftl, ftr, cone_position),
        project_point_on_line_segment(ftr, btr, cone_position),
        project_point_on_line_segment(btr, btl, cone_position),
        project_point_on_line_segment(btl, ftl, cone_position),

        // Bottom to top
        project_point_on_line_segment(fbl, ftl, cone_position),
        project_point_on_line_segment(fbr, ftr, cone_position),
        project_point_on_line_segment(bbl, btl, cone_position),
        project_point_on_line_segment(bbr, btr, cone_position)
    };

    bool in_cone = false;
    glm::vec3 best_point;
    float best_distance = std::numeric_limits<float>::infinity();
    for (auto& point: points)
    {
        float distance;
        if (is_point_in_cone(cone_position, cone_direction, cone_length, cone_radius, point, distance))
        {
            if (distance < best_distance)
            {
                best_distance = distance;
                best_point = point;
                in_cone = true;
            }
        }
    }

    if (in_cone)
    {
        point = best_point;
        return true;
    }

    return false;
}

nbunny::Probe::Probe(float cell_size) : cell_size(cell_size)
{
    // Nothing.
}

void nbunny::Probe::prepare(float frame_delta)
{
    cells.clear();
    hits.clear();
    checked_entities.clear();

    for (auto& entity: entities)
    {
        if (entity.is_active)
        {
            add(entity, frame_delta);
        }
    }
}

void nbunny::Probe::add(ProbeEntity& entity, float frame_delta)
{
    auto entity_index_iter = entity_indices.find(std::make_pair(entity.interface, entity.id));
    if (entity_index_iter == entity_indices.end())
    {
        return;
    }
    int index = entity_index_iter->second;

    const std::vector<glm::vec3> corners = {
        glm::vec3(entity.min.x, entity.min.y, entity.min.z),
        glm::vec3(entity.max.x, entity.min.y, entity.min.z),
        glm::vec3(entity.min.x, entity.max.y, entity.min.z),
        glm::vec3(entity.min.x, entity.min.y, entity.max.z),
        glm::vec3(entity.max.x, entity.max.y, entity.min.z),
        glm::vec3(entity.max.x, entity.min.y, entity.max.z),
        glm::vec3(entity.min.x, entity.max.y, entity.max.z),
        glm::vec3(entity.max.x, entity.max.y, entity.max.z)
    };

    if (entity.scene_node)
    {
        auto parent = entity.scene_node->get_parent();

        glm::mat4 transform(1.0f);
        if (parent)
        {
            transform = parent->get_transform().get_global(frame_delta);
        }

        auto current_rotation = entity.scene_node->get_transform().get_current_rotation();
        auto previous_rotation = entity.scene_node->get_transform().get_previous_rotation();
        auto interpolated_rotation = glm::slerp(previous_rotation, current_rotation, frame_delta);

        glm::vec3 min = glm::vec3(std::numeric_limits<float>::infinity());
        glm::vec3 max = glm::vec3(-std::numeric_limits<float>::infinity());

        for (auto& corner: corners)
        {
            auto transformed_corner = transform * glm::vec4(corner, 1.0);
            transformed_corner = glm::rotate(interpolated_rotation, transformed_corner);

            min = glm::min(min, glm::vec3(corner));
            max = glm::max(max, glm::vec3(corner));
        }

        entity.transformed_min = min;
        entity.transformed_max = max;
    }
    else
    {
        entity.transformed_min = entity.min;
        entity.transformed_max = entity.max;
    }

    glm::vec3 min_cell = glm::floor(entity.transformed_min * cell_size) / cell_size;
    glm::vec3 max_cell = glm::ceil(entity.transformed_max * cell_size) / cell_size;

    for (float x = min_cell.x; x <= max_cell.x; x += cell_size.x)
    {
        for (float y = min_cell.y; y <= max_cell.y; y += cell_size.y)
        {
            for (float z = min_cell.z; z <= max_cell.z; z += cell_size.z)
            {
                auto cell = glm::floor(glm::vec3(x, y, z) * cell_size) / cell_size;

                auto iter = cells.find(cell);
                if (iter == cells.end())
                {
                    std::vector<int> e = { index };
                    cells.emplace(std::make_pair(cell, e));
                }
                else
                {
                    iter->second.push_back(index);
                }
            }
        }
    }
}

void nbunny::Probe::add_or_update(const std::string& interface, int id, SceneNode* scene_node, const glm::vec3& min, const glm::vec3& max)
{
    auto iter = entity_indices.find(std::make_pair(interface, id));
    if (iter != entity_indices.end())
    {
        int index = iter->second;

        auto& entity = entities.at(index);
        entity.min = min;
        entity.max = max;
        entity.scene_node = scene_node;
    }
    else
    {
        if (!free_entity_indices.empty())
        {
            int index = free_entity_indices.back();
            free_entity_indices.pop_back();

            auto& entity = entities.at(index);

            entity.is_active = true;
            entity.interface = interface;
            entity.id = id;
            entity.min = min;
            entity.max = max;
            entity.scene_node = scene_node;
            entity_indices.insert_or_assign(std::make_pair(interface, id), index);
        }
        else
        {
            ProbeEntity entity = {};
            entity.is_active = true;
            entity.interface = interface;
            entity.id = id;
            entity.min = min;
            entity.max = max;
            entity.scene_node = scene_node;

            entities.push_back(std::move(entity));
            entity_indices.insert_or_assign(std::make_pair(interface, id), entities.size() - 1);
        }
    }
}

void nbunny::Probe::remove(const std::string& interface, int id)
{
    bool found = false;
    int index = 0;

    for (auto& entity: entities)
    {
        if (entity.interface == interface && entity.id == id)
        {
            entity.is_active = false;
            found = true;
            break;
        }

        ++index;
    }

    if (found)
    {
        entity_indices.erase(std::make_pair(interface, id));
        free_entity_indices.push_back(index);
    }
}

void nbunny::Probe::reset()
{
    entities.clear();
    entity_indices.clear();
    free_entity_indices.clear();

    cells.clear();
    hits.clear();

    checked_entities.clear();

    has_ray = false;
    has_cone = false;
}

void nbunny::Probe::probe(float frame_delta)
{
    prepare(frame_delta);

    for (auto& cell: cells)
    {
        auto min = cell.first;
        auto max = min + cell_size;

        bool hit_cell = false;

        if (has_cone)
        {
            glm::vec3 p;
            hit_cell = cone_hit_bounds(cone_position, cone_direction, cone_length, cone_radius, min, max, p);
        }

        if (!hit_cell && has_ray)
        {
            glm::vec3 p;
            hit_cell = ray_hit_bounds(ray_origin, ray_direction, min, max, p);
        }

        if (hit_cell)
        {
            for(auto index: cell.second)
            {
                if (!checked_entities.contains(index))
                {
                    checked_entities.insert(index);

                    auto& entity = entities.at(index);

                    bool hit_entity = false;
                    glm::vec3 position;
                    float distance;

                    if (has_cone)
                    {
                        hit_entity = cone_hit_bounds(cone_position, cone_direction, cone_length, cone_radius, entity.transformed_min, entity.transformed_max, position);
                        if (hit_entity)
                        {
                            distance = glm::length(position - cone_position);
                        }
                    }

                    if (!hit_entity && has_ray)
                    {
                        hit_entity = ray_hit_bounds(ray_origin, ray_direction, entity.transformed_min, entity.transformed_max, position);
                        if (hit_entity)
                        {
                            distance = glm::length(position - ray_origin);
                        }
                    }

                    if (hit_entity)
                    {
                        ProbeHit hit = {};
                        hit.interface = entity.interface;
                        hit.id = entity.id;

                        hit.position = position;
                        hit.distance = distance;

                        hits.push_back(hit);
                    }
                }
            }
        }
    }
}

void nbunny::Probe::set_ray(const glm::vec3& origin, const glm::vec3& direction)
{
    has_ray = true;
    ray_origin = origin;
    ray_direction = direction;
}

void nbunny::Probe::unset_ray()
{
    has_ray = false;
}

void nbunny::Probe::set_cone(const glm::vec3& position, const glm::vec3& direction, float length, float radius)
{
    has_cone = true;
    cone_position = position;
    cone_direction = direction;
    cone_length = length;
    cone_radius = radius;
}

void nbunny::Probe::unset_cone()
{
    has_cone = false;
}

int nbunny::Probe::get_num_hits() const
{
    return (int)hits.size();
}

nbunny::ProbeHit nbunny::Probe::get_hit(int index) const
{
    return hits.at(index);
}

static int nbunny_probe_add_or_update(lua_State* L)
{
    auto probe = nbunny::lua::get<nbunny::Probe*>(L, 1);
    const char* interface = luaL_checkstring(L, 2);
    int id = luaL_checkinteger(L, 3);

    nbunny::SceneNode* scene_node = nullptr;
    if (!lua_isnil(L, 4))
    {
        scene_node = nbunny::lua::get<nbunny::SceneNode*>(L, 4);
    }

    float min_x = luaL_checknumber(L, 5);
    float min_y = luaL_checknumber(L, 6);
    float min_z = luaL_checknumber(L, 7);

    float max_x = luaL_checknumber(L, 8);
    float max_y = luaL_checknumber(L, 9);
    float max_z = luaL_checknumber(L, 10);

    probe->add_or_update(interface, id, scene_node, glm::vec3(min_x, min_y, min_z), glm::vec3(max_x, max_y, max_z));

    return 0;
}

static int nbunny_probe_remove(lua_State* L)
{
    auto probe = nbunny::lua::get<nbunny::Probe*>(L, 1);

    const char* interface = luaL_checkstring(L, 2);
    int id = luaL_checkinteger(L, 3);

    probe->remove(interface, id);

    return 0;
}

static int nbunny_probe_reset(lua_State* L)
{
    auto probe = nbunny::lua::get<nbunny::Probe*>(L, 1);
    probe->reset();

    return 0;
}

static int nbunny_probe_set_ray(lua_State* L)
{
    auto probe = nbunny::lua::get<nbunny::Probe*>(L, 1);

    float origin_x = luaL_checknumber(L, 2);
    float origin_y = luaL_checknumber(L, 3);
    float origin_z = luaL_checknumber(L, 4);

    float direction_x = luaL_checknumber(L, 5);
    float direction_y = luaL_checknumber(L, 6);
    float direction_z = luaL_checknumber(L, 7);

    probe->set_ray(glm::vec3(origin_x, origin_y, origin_z), glm::vec3(direction_x, direction_y, direction_z));

    return 0;
}

static int nbunny_probe_unset_ray(lua_State* L)
{
    auto probe = nbunny::lua::get<nbunny::Probe*>(L, 1);
    probe->unset_ray();

    return 0;
}

static int nbunny_probe_set_cone(lua_State* L)
{
    auto probe = nbunny::lua::get<nbunny::Probe*>(L, 1);

    float position_x = luaL_checknumber(L, 2);
    float position_y = luaL_checknumber(L, 3);
    float position_z = luaL_checknumber(L, 4);

    float direction_x = luaL_checknumber(L, 5);
    float direction_y = luaL_checknumber(L, 6);
    float direction_z = luaL_checknumber(L, 7);

    float length = luaL_checknumber(L, 8);
    float radius = luaL_checknumber(L, 9);

    probe->set_cone(
        glm::vec3(position_x, position_y, position_z),
        glm::vec3(direction_x, direction_y, direction_z),
        length,
        radius);

    return 0;
}

static int nbunny_probe_unset_cone(lua_State* L)
{
    auto probe = nbunny::lua::get<nbunny::Probe*>(L, 1);
    probe->unset_cone();

    return 0;
}

static int nbunny_probe_probe(lua_State* L)
{
    auto probe = nbunny::lua::get<nbunny::Probe*>(L, 1);
    float frame_delta = luaL_checknumber(L, 2);
    probe->probe(frame_delta);

    nbunny::lua::push(L, probe->get_num_hits());

    return 1;
}

static int nbunny_probe_get_num_hits(lua_State* L)
{
    auto probe = nbunny::lua::get<nbunny::Probe*>(L, 1);
    nbunny::lua::push(L, probe->get_num_hits());
    return 1;
}

static int nbunny_probe_get_hit(lua_State* L)
{
    auto probe = nbunny::lua::get<nbunny::Probe*>(L, 1);
    int index = luaL_checkinteger(L, 2);
    auto hit = probe->get_hit(index);

    nbunny::lua::push(L, hit.interface);
    nbunny::lua::push(L, hit.id);
    nbunny::lua::push(L, hit.position.x);
    nbunny::lua::push(L, hit.position.y);
    nbunny::lua::push(L, hit.position.z);
    nbunny::lua::push(L, hit.distance);

    return 6;
}

static int nbunny_probe_constructor(lua_State* L)
{
    float cell_size = luaL_checknumber(L, 2);
    nbunny::lua::push(L, std::make_shared<nbunny::Probe>(cell_size));
    return 1;
}

extern "C"
NBUNNY_EXPORT int luaopen_nbunny_optimaus_probe(lua_State* L)
{
    static const luaL_Reg metatable[] = {
        { "addOrUpdate", &nbunny_probe_add_or_update },
        { "remove", &nbunny_probe_remove },
        { "reset", &nbunny_probe_reset },
        { "setRay", &nbunny_probe_set_ray },
        { "unsetRay", &nbunny_probe_unset_ray },
        { "setCone", &nbunny_probe_set_cone },
        { "unsetCone", &nbunny_probe_unset_cone },
        { "probe", &nbunny_probe_probe },
        { "getNumHits", &nbunny_probe_get_num_hits },
        { "getHit", &nbunny_probe_get_hit },
        { nullptr, nullptr }
    };

    nbunny::lua::register_type<nbunny::Probe>(L, &nbunny_probe_constructor, metatable);

    return 1;
}
