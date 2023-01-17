local deck = {}
deck.__index = deck
deck.__tostring = function(d) 
    local c = {}
    for i = 1, #d do
        c[#c + 1] = d[i].name
    end
    return "Cards in " .. d.name .. "(" .. #d .. "): " .. table.concat(c, ", ") 
end
deck.Type = "deck"

local card = {}
card.__index = card
card.__tostring = function(c) return c.name end
card.Type = "card"

function card:new(name, data)
    local c = {}
    c.name = tostring(name) or error("You must supply a name for a card!")
    -- copy data, don't reference it directly
    if type(data) == "table" then
        for i, v in pairs(data) do
            c[i] = v
        end
    end
    setmetatable(c, card)
    return c
end

local d_counter = 0
function deck:new(name)
    local d = {}
    d.name = tostring(name) or "Unnamed deck " .. d_counter
    d.discard = {}
    setmetatable(d, deck)
    d_counter = d_counter + 1
    return d
end

function deck:setDiscard(deck)
    self.discard = deck or deck:new("Discard pile")
    return self.discard
end

function deck:getDiscard()
    return self.discard
end

function deck:reset()
    self:shuffle(self.discard)
end

function deck:add(c)
    if type(c) == "string" then c = card:new(c) end
    table.insert(self, c)
    return self
end

function deck:shuffle(deck)
    if type(deck) == "table" and deck.Type == "deck" then
        while #deck ~= 0 do
            self:add(deck:draw())
        end
    end
    local n = #self
    while n > 2 do
        local k = math.random(n)
        self[n], self[k] = self[k], self[n]
        n = n - 1
    end
    return self
end

function deck:draw(n)
    if n then
        local cards = deck:new("Draw")
        for i = 1, n do
            cards:add(self:draw())
        end
        return cards
    else
        local card = table.remove(self, 1)
        if card then
            table.insert(self.discard, card)
        end
        return card
    end
end

local function findHelper(card1, card2)
    return card1.name == card2.name
end

function deck:find(card, func)
    local func = func or findHelper
    for i, v in ipairs(deck) do
        if findHelper(v, card) then
            return i
        end
    end
    return nil
end

function deck:peek(n)
    if not n or n == 1 then return self[1] end
    local cards = deck:new("Peek")
    for i = 1, n do
        cards:add(self[i])
    end
    return cards
end

-- init function
return {init = function() return deck, card end}