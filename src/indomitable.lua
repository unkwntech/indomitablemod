SMODS.Joker {
    key = 'indomitable',
    rarity = 1, --common
    cost = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, info_queue, card) 
        return {
            vars ={
                G.GAME.current_round.indomitable_currentMult,
                G.GAME.current_round.indomitable_increment
            }
        }
    end,
    loc_txt = {
        label = "Indomitable",
        name = "Indomitable Joker",
        text = {"Adds {C:mult}x#2#{} each time", "the most played hand", "is discarded.", "Currently {C:mult}x#1#{} Mult"}
    },
    calculate = function (self, card, context) 
        if context.pre_discard then
            local handName = G.FUNCS.get_poker_hand_info(context.full_hand)
            local isTop = true
            local hasPlayed = false

            for k, v in pairs(G.GAME.hands) do 
                -- Check that some hand has been played at least once
                if G.GAME.hands[handName].played > 0 then
                    hasPlayed = true
                end
                -- Check if any hand has been played more than the current one
                if k ~= handName and v.played > (G.GAME.hands[handName].played or 0) then
                    isTop = false
                end
            end

            if isTop and hasPlayed then
                G.GAME.current_round.indomitable_currentMult = (G.GAME.current_round.indomitable_currentMult or 0) + (G.GAME.current_round.indomitable_increment or 0)
                return {
                    discard = true,
                    message = "Upgrade!"
                }
            end
        end

        if context.joker_main then
            return {
                xmult = G.GAME.current_round.indomitable_currentMult
            }
        end

        if context.selling_self then
            G.GAME.current_round.indomitable_currentMult = 0.7
            G.GAME.current_round.indomitable_increment = 0.15
        end 
    end,
}

SMODS.current_mod.reset_game_globals = function(run_start)
    if run_start then
        G.GAME.current_round.indomitable_currentMult = 0.7
        G.GAME.current_round.indomitable_increment = 0.15
    end
end