#include "nbunny/nbunny.hpp"
#include "nbunny/lua_runtime.hpp"

nbunny::lua::TemporaryReference::TemporaryReference(lua_State* L, int index) :
    L(L), reference(reference)
{
    // Nothing.
}

nbunny::lua::TemporaryReference::TemporaryReference(const TemporaryReference& other)
{
    *this = other;
}

nbunny::lua::TemporaryReference::TemporaryReference(TemporaryReference&& other)
{
    *this = other;
}

nbunny::lua::TemporaryReference::~TemporaryReference()
{
    reset();
}

void nbunny::lua::TemporaryReference::push() const
{
    if (!is_valid())
    {
        throw std::runtime_error("reference is invalid");
    }

    lua_rawgeti(L, LUA_REGISTRYINDEX, reference);
}

void nbunny::lua::TemporaryReference::reset()
{
    if (L && reference != LUA_NOREF)
    {
        luaL_unref(L, LUA_REGISTRYINDEX, reference);
    }

    L = nullptr;
    reference = LUA_NOREF;
}

int nbunny::lua::TemporaryReference::fork()
{
    int old_reference = reference;

    L = nullptr;
    reference = LUA_NOREF;

    return old_reference;
}

bool nbunny::lua::TemporaryReference::is_valid() const
{
    return L && reference != LUA_NOREF;
}

nbunny::lua::TemporaryReference& nbunny::lua::TemporaryReference::operator =(const TemporaryReference& other)
{
    reset();

    other.push();
    L = other.L;
    reference = luaL_ref(L, LUA_REGISTRYINDEX);

    return *this;
}

nbunny::lua::TemporaryReference& nbunny::lua::TemporaryReference::operator =(TemporaryReference&& other)
{
    reset();

    L = other.L;
    reference = other.reference;

    other.L = nullptr;
    other.reference = LUA_NOREF;

    return *this;
}
