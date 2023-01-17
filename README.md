# Readme

Simple library for managing a deck of cards

Example:
```lua
math.randomseed(os.time())
local deck, card = require("deck"):init()

local play = deck:new("Playing cards")
local discard = deck:new("Discard")

local suits = {"hearts", "diamonds", "clubs", "spades"}
local values = {"Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"}

local id = 0
for i, suit in ipairs(suits) do
    for j, value in ipairs(values) do
        play:add(card:new(value .. " of " .. suit, {ID = id}))
        id = id + 1
    end
end

play:setDiscard(discard) -- Set discard pile, automatically puts "dealt" cards into the discard pile. Alternatively, you could just put the players hands ("decks") back into deck using shuffle(playerDeck)
print(play)
play:shuffle()

print(play)
print("----")
print(play:draw(5))
print("----")
print(play)

while #play ~= 0 do
    print(play:draw())
end

print("Play:", #play)
print("Discard:", #discard)

play:shuffle(discard)

print("Play:", #play)
print("Discard:", #discard)

local c = play:peek()
print("Peeking:", c, "ID:", c.ID)
```