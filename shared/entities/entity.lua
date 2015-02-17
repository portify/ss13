local class = require "../lib/class"
local entity = class:extend()

function entity:new(game, id, ...)
    local is_ghost = id ~= nil

    local new = class.new(self, {
        game = game,
        is_ghost = is_ghost,
        __id = id,
        weak = setmetatable({}, {__mode = "kv"})
    })

    new:__init(...)

    if is_ghost then
        game.entities[id] = new
    else -- TODO: move add_entity here
        game:add_entity(new)
    end

    return new
end

-- call this instead of wrapping in add_entity()
-- when making a new entity
function entity:register(id)
    if id == nil then
    end
end

function entity:remove(...)
    self:__remove(...)

    if self.__id then
        if not self.is_ghost then
            self.game:send{e = EVENT.ENTITY_REMOVE, self.__id}
        end

        self.game.entities[self.__id] = nil
        self.__id = nil
    end
end

function entity:__remove()
end

function entity:pack(type)
    return nil
end

function entity:unpack(t, type)
    assert(t == nil, "invalid unpack")
end

function entity:update(dt)
end

function entity:draw()
end

function entity:get_type_id()
    return id_from_entity(getmetatable(self))
end

return entity
