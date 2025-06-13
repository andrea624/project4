
local Card = {}
Card.__index = Card

-- holds the card's data
local card_data = {
    ["Wooden Cow"] = { cost = 1, power = 1, text = "Vanilla", type = "vanilla" },
    ["Pegasus"] = { cost = 3, power = 5, text = "Vanilla", type = "vanilla" },
    ["Minotaur"] = { cost = 5, power = 9, text = "Vanilla", type = "vanilla" },
    ["Titan"] = { cost = 6, power = 12, text = "Vanilla", type = "vanilla" },

    ["Zeus"] = { cost = 6, power = 7, text = "When Revealed: Lower the power of each card in your opponent's hand by 1.", trigger = "onReveal", effect = "zeus" },
    ["Ares"] = { cost = 5, power = 5, text = "When Revealed: Gain +2 power for each enemy card here.", trigger = "onReveal", effect = "ares" },
    ["Medusa"] = { cost = 4, power = 4, text = "When ANY other card is played here, lower that card's power by 1.", trigger = "onPlayOther", effect = "medusa" },
    ["Cyclops"] = { cost = 5, power = 4, text = "When Revealed: Discard your other cards here, gain +2 power for each discarded.", trigger = "onReveal", effect = "cyclops" },
    ["Poseidon"] = { cost = 5, power = 5, text = "When Revealed: Move away an enemy card here with the lowest power.", trigger = "onReveal", effect = "poseidon" },
    ["Artemis"] = { cost = 4, power = 4, text = "When Revealed: Gain +5 power if there is exactly one enemy card here.", trigger = "onReveal", effect = "artemis" },
    ["Hera"] = { cost = 4, power = 3, text = "When Revealed: Give cards in your hand +1 power.", trigger = "onReveal", effect = "hera" },
    ["Demeter"] = { cost = 3, power = 2, text = "When Revealed: Both players draw a card.", trigger = "onReveal", effect = "demeter" },
    ["Hades"] = { cost = 5, power = 3, text = "When Revealed: Gain +2 power for each card in your discard pile.", trigger = "onReveal", effect = "hades" },
    ["Hercules"] = { cost = 5, power = 6, text = "When Revealed: Doubles its power if it's the strongest card here.", trigger = "onReveal", effect = "hercules" },
    ["Dionysus"] = { cost = 3, power = 2, text = "When Revealed: Gain +2 power for each of your other cards here.", trigger = "onReveal", effect = "dionysus" },
    ["Hermes"] = { cost = 4, power = 3, text = "When Revealed: Moves to another location.", trigger = "onReveal", effect = "hermes" },
    ["Hydra"] = { cost = 3, power = 2, text = "Add two copies to your hand when this card is discarded.", trigger = "onDiscard", effect = "hydra" },
    ["Ship of Theseus"] = { cost = 4, power = 3, text = "When Revealed: Add a copy with +1 power to your hand.", trigger = "onReveal", effect = "shipoftheseus" },
    ["Sword of Damocles"] = { cost = 4, power = 5, text = "End of Turn: Loses 1 power if not winning this location.", trigger = "onEnd", effect = "swordofdamocles" },
    ["Midas"] = { cost = 4, power = 3, text = "When Revealed: Set ALL cards here to 3 power.", trigger = "onReveal", effect = "midas" },
    ["Aphrodite"] = { cost = 3, power = 3, text = "When Revealed: Lower the power of each enemy card here by 1.", trigger = "onReveal", effect = "aphrodite" },
    ["Athena"] = { cost = 3, power = 2, text = "Gain +1 power when you play another card here.", trigger = "onPlayOther", effect = "athena" },
    ["Apollo"] = { cost = 2, power = 2, text = "When Revealed: Gain +1 mana next turn.", trigger = "onReveal", effect = "apollo" },
    ["Hephaestus"] = { cost = 4, power = 3, text = "When Revealed: Lower the cost of 2 cards in your hand by 1.", trigger = "onReveal", effect = "hephaestus" },
    ["Persephone"] = { cost = 2, power = 2, text = "When Revealed: Discard the lowest power card in your hand.", trigger = "onReveal", effect = "persephone" },
    ["Prometheus"] = { cost = 3, power = 3, text = "When Revealed: Draw a card from your opponent's deck.", trigger = "onReveal", effect = "prometheus" },
    ["Pandora"] = { cost = 2, power = 6, text = "When Revealed: If no ally cards are here, lower this card's power by 5.", trigger = "onReveal", effect = "pandora" },
    ["Icarus"] = { cost = 1, power = 1, text = "End of Turn: Gains +1 power, but is discarded when its power is greater than 7.", trigger = "onEnd", effect = "icarus" },
    ["Iris"] = { cost = 3, power = 2, text = "End of Turn: Give your cards at each other location +1 power if they have unique powers.", trigger = "onEnd", effect = "iris" },
    ["Nyx"] = { cost = 5, power = 2, text = "When Revealed: Discards your other cards here, add their power to this card.", trigger = "onReveal", effect = "nyx" },
    ["Atlas"] = { cost = 4, power = 5, text = "End of Turn: Loses 1 power if your side of this location is full.", trigger = "onEnd", effect = "altas" },
    ["Daedalus"] = { cost = 3, power = 3, text = "When Revealed: Add a Wooden Cow to each other location.", trigger = "onReveal", effect = "daedalus" },
    ["Helios"] = { cost = 4, power = 4, text = "End of Turn: Discard this.", trigger = "onEnd", effect = "helios" },
    ["Mnemosyne"] = { cost = 3, power = 2, text = "When Revealed: Add a copy of the last card you played to your hand.", trigger = "onReveal", effect = "mnemosyne" },
}

function Card:new(name)
    local data = card_data[name]
    assert(data, "Card not found: " .. tostring(name))

    local card = {
        name = name,
        cost = data.cost or 0,
        power = data.power or 0,
        text = data.text or "",
        type = data.type or "",
        trigger = data.trigger,
        effect = data.effect,
        x = 0,
        y = 0,
        width = 50,
        height = 70,
    }

    setmetatable(card, Card)
    return card
end

function Card:isHovered(mx, my)
    return mx >= self.x and mx <= (self.x + self.width) and
           my >= self.y and my <= (self.y + self.height)
end

function Card:draw(x, y, w, h)
    w = w or 50
    h = h or 70

    self.x = x
    self.y = y
    self.width = w
    self.height = h
    
    love.graphics.setNewFont(10)
    love.graphics.setColor(1, 1, 1, 1) 
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(0, 0, 0, 1) 
    love.graphics.rectangle("line", x, y, w, h)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(self.name, x + 5, y + 5, w - 10, "center")

    love.graphics.setNewFont(8)
    love.graphics.printf("Cost: " .. self.cost, x + 5, y + 15, 90, "left")
    love.graphics.printf("Power: " .. self.power, x + 5, y + 22, 90, "left")

    love.graphics.printf(self.text, x + 5, y + 32, 90, "left")
end

return Card