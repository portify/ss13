require "enet"
mp = require "../lib/msgpack"

require "../shared/const"
require "../shared/debug"
require "../shared/entities"

gamestate = require "../shared/hump/gamestate"

states = {
    menu = require "states/menu",
    connecting = require "states/connecting",
    game = require "states/game",
    pause = require "states/pause"
}

function love.load()
    debug_patch()
    local expect

    for i=2, #arg do
        if expect ~= nil then
            if expect == "--connect" then
                CONNECT_TO = arg[i]
            end
            expect = nil
        elseif arg[i] == "--connect" then
            expect = "--connect"
        else
            print("Unknown command line argument " .. arg[i])
            love.event.quit()
            return
        end
    end

    gamestate.registerEvents()

    if CONNECT_TO ~= nil then
        gamestate.switch(states.connecting, CONNECT_TO)
    else
        gamestate.switch(states.menu)
    end
end
