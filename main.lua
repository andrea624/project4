-- Andrea Martinez & Andrea Morales Villegas
-- CMPM 121 Project 4

require "vector"
local Card = require("card")

local CARD_WIDTH = 50
local CARD_HEIGHT = 70

local swordImg
local titleBackground
local creditsBackground
local backgroundMusic

local gameState = "menu"

local hand = {}

local selectedCard = nil
local mouseOffsetX, mouseOffsetY = 0, 0
local locations = {
    {x = 100, y = 475, cards = {}},
    {x = 360, y = 475, cards = {}},
    {x = 620, y = 475, cards = {}}
}
local discardPile = {}
local discardPilePos = { x = 800, y = 100 }
local deck = {}
local drawPilePos = { x = 800, y = 200 }

local submitButton = {x = 800, y = 550, width = 100, height = 40}
local turn = 1
local mana = 1
local hasSubmitted = false

function love.load()
  backgroundMusic = love.audio.newSource("assets/music/medieval.mp3", "stream")
  backgroundMusic:setLooping(true)
  backgroundMusic:setVolume(0.3)
  backgroundMusic:play()
    
  love.graphics.setBackgroundColor(0.5, 0.5, 0.3, 1)
  love.window.setTitle("3CG: The Clash")
  love.window.setMode(960, 640)
  swordImg = love.graphics.newImage("assets/sword.png")
  titleBackground = love.graphics.newImage("assets/back.png")
  creditsBackground = love.graphics.newImage("assets/credits.png")

  local cardDeckNames = {"Zeus", "Ares","Medusa", "Cyclops", "Poseidon", "Artemis", "Hera", "Demeter", "Hades", "Hercules", "Dionysus", "Hermes", "Hydra", "Ship of Theseus", "Sword of Damocles", "Midas", "Aphrodite", "Athena", "Apollo", "Hephaestus", "Persephone", "Prometheus", "Pandora", "Icarus", "Iris", "Nyx", "Atlas", "Daedalus", "Helios", "Mnemosyne"
  }

  for _, name in ipairs(cardDeckNames) do
    table.insert(deck, Card:new(name))
  end

  for i = #deck, 2, -1 do
    local j = love.math.random(i)
      deck[i], deck[j] = deck[j], deck[i]
  end
  for i = 1, 3 do drawCard() end
end

function drawCard()
    if #deck > 0 and #hand < 7 then
        local card = table.remove(deck, 1)
        table.insert(hand, card)
    end
end

function startTurn()
    turn = turn + 1
    mana = turn
    hasSubmitted = false
    for _, loc in ipairs(locations) do
        for _, card in ipairs(loc.cards) do
            table.insert(discardPile, card)
        end
        loc.cards = {}
    end
end

function love.draw()
  -- menu
    if gameState == "menu" then
      love.graphics.draw(titleBackground, 0, 0)
  
      love.graphics.draw(swordImg, 200, 90, 0, 0.1, 0.1) 
      love.graphics.draw(swordImg, 760, 150, -85, 0.1, 0.1)
      


      
      love.graphics.setFont(love.graphics.newFont(64))
      love.graphics.setColor(0.7, 0.023, 0.09, 1)
      love.graphics.printf("The Clash", 0, 100, love.graphics.getWidth(), "center")
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.setFont(love.graphics.newFont(16))
      love.graphics.printf("Press [Enter/Return] to Start", 0, 300, love.graphics.getWidth(), "center")
      love.graphics.printf("Press [C] for Credits", 0, 330, love.graphics.getWidth(), "center")
      return
    end
      -- credits
      if gameState == "credits" then
        love.graphics.setBackgroundColor(0.2, 0.2, 0.2, 1)
        love.graphics.draw(creditsBackground, 0, 0)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("Press [Q] to return", 0, 300, love.graphics.getWidth(), "center")
        return
      end
  
  
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Mana: " .. mana, 20, 20)
    for i, card in ipairs(hand) do
        local x = 50 + (i - 1) * (CARD_WIDTH + 45)
        local y = 100
        card.x = x
        card.y = y
        card:draw(x, y, CARD_WIDTH, CARD_HEIGHT)
    end

    for i, location in ipairs(locations) do
        love.graphics.setColor(0.8, 0.8, 0.9, 1)
        love.graphics.printf("Location " .. i, location.x, location.y - 25, CARD_WIDTH * 4 + 15, "center")

        for s = 0, 3 do
            local slotX = location.x + s * (CARD_WIDTH + 5)
            local slotY = location.y
            love.graphics.rectangle("line", slotX, slotY, CARD_WIDTH, CARD_HEIGHT)

            local card = location.cards[s + 1]
            if card then
                card:draw(slotX + 5, slotY + 5, CARD_WIDTH - 10, CARD_HEIGHT - 10)
            end
        end
    end

    -- discard pile
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", discardPilePos.x, discardPilePos.y, CARD_WIDTH, CARD_HEIGHT)
    love.graphics.printf("Discard Pile", discardPilePos.x, discardPilePos.y - 30, CARD_WIDTH, "center")

    local topDiscard = discardPile[#discardPile]
    if topDiscard then
        topDiscard:draw(discardPilePos.x + 5, discardPilePos.y + 5, CARD_WIDTH - 10, CARD_HEIGHT - 10)
    end
    -- drawing pile
    love.graphics.rectangle("line", drawPilePos.x, drawPilePos.y, CARD_WIDTH, CARD_HEIGHT)
    love.graphics.printf("Draw", drawPilePos.x, drawPilePos.y - 30, CARD_WIDTH, "center")


    love.graphics.rectangle("line", submitButton.x, submitButton.y, submitButton.width, submitButton.height)
    love.graphics.printf("Submit", submitButton.x, submitButton.y + 10, submitButton.width, "center")
    if selectedCard then
        selectedCard:draw(love.mouse.getX() - mouseOffsetX, love.mouse.getY() - mouseOffsetY, CARD_WIDTH, CARD_HEIGHT)
    end
end

function love.mousepressed(x, y, button)
  -- checking game state
  if gameState ~= "game" then return end
  if button == 1 then
    for i, card in ipairs(hand) do
      if x > card.x and x < card.x + CARD_WIDTH and y > card.y and y < card.y + CARD_HEIGHT then
        selectedCard = card
        mouseOffsetX = x - card.x
        mouseOffsetY = y - card.y
        table.remove(hand, i)
        return
      end
    end

    if x > drawPilePos.x and x < drawPilePos.x + CARD_WIDTH and y > drawPilePos.y and y < drawPilePos.y + CARD_HEIGHT then
      drawCard()
    end

    if x > submitButton.x and x < submitButton.x + submitButton.width and y > submitButton.y and y < submitButton.y + submitButton.height then
      for _, card in ipairs(hand) do
        for _, loc in ipairs(locations) do
          if #loc.cards < 4 then
            table.insert(loc.cards, card)
            break
          end
        end
      end
      hand = {}
      startTurn()
    end
  end
end

function love.mousereleased(x, y, button)
  if gameState ~= "game" then return end
  if button == 1 and selectedCard then
    for _, loc in ipairs(locations) do
      for s = 0, 3 do
        local slotX = loc.x + s * (CARD_WIDTH + 5)
        local slotY = loc.y
        if x > slotX and x < slotX + CARD_WIDTH and y > slotY and y < slotY + CARD_HEIGHT then
          if not loc.cards[s + 1] then
            loc.cards[s + 1] = selectedCard
            selectedCard = nil
            return
          end
        end
      end
    end
    table.insert(hand, selectedCard)
    selectedCard = nil
    end
end
function love.keypressed(key)
  if key == "c" then
    gameState = "credits"
  elseif gameState == "credits" and key == "q" then
    gameState = "menu"
  elseif gameState == "menu" and (key == "return" or key == "enter") then
    gameState = "game"
  end
end