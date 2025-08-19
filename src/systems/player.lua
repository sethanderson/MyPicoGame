player = { x = 64, y = 64, speed = 1.25, anim_tick = 0, anim_rate = 6, anim_frame = 1, moving = false, dir = "idle" }

local base = { idle = 0, up = 1, right = 2, down = 3, upright = 4, downright = 5 }

local function input_vec()
    local vx, vy = 0, 0
    if btn(0) then vx -= 1 end
    if btn(1) then vx += 1 end
    if btn(2) then vy -= 1 end
    if btn(3) then vy += 1 end
    return vx, vy
end

local function dir_name(vx, vy)
    if vx == 0 and vy == 0 then return "idle" end
    if vy < 0 and vx == 0 then return "up" end
    if vy > 0 and vx == 0 then return "down" end
    if vx > 0 and vy == 0 then return "right" end
    if vx < 0 and vy == 0 then return "left" end
    if vx > 0 and vy < 0 then return "upright" end
    if vx > 0 and vy > 0 then return "downright" end
    if vx < 0 and vy < 0 then return "upleft" end
    if vx < 0 and vy > 0 then return "downleft" end
    return "idle"
end

local function norm(vx, vy)
    if vx ~= 0 and vy ~= 0 then
        local k = 0.7071
        return vx * k, vy * k
    end
    return vx, vy
end

function init_player()
    player.x, player.y = 64, 64
    player.anim_tick, player.anim_frame, player.moving, player.dir = 0, 1, false, "idle"
end

function update_player()
    local vx, vy = input_vec()
    player.moving = (vx ~= 0 or vy ~= 0)
    player.dir = dir_name(vx, vy)
    vx, vy = norm(vx, vy)
    player.x += vx * player.speed
    player.y += vy * player.speed

    if player.moving then
        player.anim_tick = (player.anim_tick + 1) % (player.anim_rate * 2)
        if player.anim_tick % player.anim_rate == 0 then
            player.anim_frame = (player.anim_frame == 1) and 2 or 1
        end
    else
        player.anim_frame, player.anim_tick = 1, 0
    end
end

function draw_player()
    local dir, flipx = player.dir, false
    if dir == "left" then
        dir, flipx = "right", true
    elseif dir == "upleft" then
        dir, flipx = "upright", true
    elseif dir == "downleft" then
        dir, flipx = "downright", true
    end

    local idx = (base[dir] or base.idle)
    if player.anim_frame == 2 then idx += 16 end
    spr(idx, flr(player.x), flr(player.y), 1, 1, flipx, false)
end
