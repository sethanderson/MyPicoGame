function _init()
    init_player()
    init_game()
end

function _update60()
    update_player()
    update_game()
end

function _draw()
    cls()
    draw_player()
    draw_game()
end
