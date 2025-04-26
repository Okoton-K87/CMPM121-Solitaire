require "card"
require "grabber"
require "pile"

grabber = nil
cardTable = nil
piles = nil
mousePreviouslyDown = false

function love.load()
  love.window.setMode(1280, 720)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)

  grabber = Grabber:new()
  cardTable = {}
  piles = {}

  -- Create tableau piles (7 piles)
  for i = 1, 7 do
    table.insert(piles, Pile:new(100 + (i-1) * 100, 300, "tableau"))
  end

  -- Create suit piles (4 piles)
  for i = 1, 4 do
    table.insert(piles, Pile:new(600 + (i-1) * 100, 100, "suit"))
  end

  -- Create deck pile (1 pile)
  table.insert(piles, Pile:new(100, 100, "deck"))

  -- Create draw pile (1 pile)
  table.insert(piles, Pile:new(220, 100, "draw"))

  -- Build and shuffle full deck
  local suits = {"heart", "diamond", "club", "spade"}
  local ranks = {1,2,3,4,5,6,7,8,9,10,11,12,13}
  local fullDeck = {}

  for _, suit in ipairs(suits) do
    for _, rank in ipairs(ranks) do
      table.insert(fullDeck, {suit = suit, rank = rank})
    end
  end

  -- Shuffle deck
  for i = #fullDeck, 2, -1 do
    local j = love.math.random(i)
    fullDeck[i], fullDeck[j] = fullDeck[j], fullDeck[i]
  end

  -- Deal into tableau piles
  local deckIndex = 1
  for pileIndex = 1, 7 do
    for cardNum = 1, pileIndex do
      local cardData = fullDeck[deckIndex]
      local faceUp = (cardNum == pileIndex) -- only top card face up
      local card = Card:new(0, 0, cardData.suit, cardData.rank, faceUp)
      piles[pileIndex]:addCard(card)
      table.insert(cardTable, card)
      deckIndex = deckIndex + 1
    end
  end

  -- Remaining cards into deck pile
  for i = deckIndex, #fullDeck do
    local cardData = fullDeck[i]
    local card = Card:new(0, 0, cardData.suit, cardData.rank, false)
    piles[12]:addCard(card)
    table.insert(cardTable, card)
  end
end

function love.update()
  grabber:update()

  checkForMouseMoving()

  -- Check for deck click
  if love.mouse.isDown(1) and not mousePreviouslyDown then
    checkDeckClick()
  end
  mousePreviouslyDown = love.mouse.isDown(1)

  for _, card in ipairs(cardTable) do
    card:update()
  end
end

function love.draw()
  for _, pile in ipairs(piles) do
    pile:draw()
  end

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. tostring(grabber.currentMousePos.y))
end

function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end

  for _, card in ipairs(cardTable) do
    card:checkForMouseOver(grabber)
  end
end

function checkDeckClick()
  local deckPile = piles[12]
  local drawPile = piles[13]

  local mx, my = love.mouse.getX(), love.mouse.getY()

  if mx > deckPile.position.x and mx < deckPile.position.x + 71 and
     my > deckPile.position.y and my < deckPile.position.y + 96 then

    -- Clear old draw pile
    for i = #drawPile.cards, 1, -1 do
      table.remove(drawPile.cards, i)
    end

    -- Draw up to 3 cards
    for i = 1, 3 do
      local card = deckPile:removeTopCard()
      if card then
        card.faceUp = true
        drawPile:addCard(card)
      else
        break
      end
    end

    -- Offset drawn cards horizontally
    for i, card in ipairs(drawPile.cards) do
      card.position = Vector(drawPile.position.x + (i-1) * 20, drawPile.position.y)
    end
  end
end
