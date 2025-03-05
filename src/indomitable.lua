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

local atlas_key = "birb_deck_skin" -- Format: PREFIX_KEY
-- See end of file for notes
local atlas_path = "birb_lc.png" -- Filename for the image in the asset folder
local atlas_path_hc = "birb_hc.png" -- Filename for the high-contrast version of the texture, if existing

local suits = {"hearts", "clubs", "diamonds", "spades"} -- Which suits to replace
local ranks = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"} -- Which ranks to replace

local description = "The Spiciest Birbs!" -- English-language description, also used as default

-----------------------------------------------------------
-- You should only need to change things above this line --
-----------------------------------------------------------

local atlas_lc = SMODS.Atlas {  
    key = atlas_key .. "_lc",
    px = 71,
    py = 95,
    path = atlas_path,
}

local atlas_hc = SMODS.Atlas {  
    key = atlas_key .. "_hc",
    px = 71,
    py = 95,
    path = atlas_path_hc,
}

local atlas_icon = SMODS.Atlas {
    key = atlas_key .. "_icon",
    path = "icon.png",
    px = 18,
    py = 18
}

for _, suit in ipairs(suits) do
    SMODS.DeckSkin{
        key = suit .. "_skin",
        suit = suit:gsub("^%l", string.upper),
        palettes = {
            {
                key = "lc",
                ranks = ranks,
                display_ranks = {"Jack", "Queen", "King"},
                atlas = atlas_lc.key,
                pos_style = "deck",
                suit_icon = {
                    atlas = atlas_icon.key
                }
            },
            {
                key = "hc",
                ranks = ranks,
                display_ranks = {"Jack", "Queen", "King"},
                atlas = atlas_hc.key,
                pos_style = "deck",
                suit_icon = {
                    atlas = atlas_icon.key
                }
            }
        },
        -- ranks = ranks,
        -- lc_atlas = atlas_key .. "_lc",
        -- hc_atlas = atlas_path_hc and atlas_key .. "_hc",
        loc_txt = {
            ["en-us"] = description
        },
        -- posStyle = "deck"
    }
end

-- Notes:

-- The current version of Steamodded has a bug with prefixes in mods including `DeckSkin`s.
-- By manually including the prefix in the atlas' key, this should keep the mod functional
-- even after this bug is fixed.
