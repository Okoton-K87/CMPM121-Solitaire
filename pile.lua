require "vector"

Pile = {}

function Pile:new(xPos, yPos, pileType)
  local pile = setmetatable({}, {__index = Pile})

  pile.position = Vector(xPos, yPos)
  pile.cards = {}
  pile.type = pileType -- "tableau", "suit", "deck", "draw"
  
  return pile
end

function Pile:addCard(card)
  table.insert(self.cards, card)
  self:updateCardPositions()
end

function Pile:removeTopCard()
  return table.remove(self.cards)
end

function Pile:getTopCard()
  return self.cards[#self.cards]
end

function Pile:updateCardPositions()
  -- Adjust card positions based on pile type
  local spacing = 20 -- Default vertical spacing

  if self.type == "deck" or self.type == "draw" or self.type == "suit" then
    spacing = 0 -- Cards stacked perfectly
  end

  for i, card in ipairs(self.cards) do
    card.position = Vector(self.position.x, self.position.y + (i - 1) * spacing)
  end
end

function Pile:draw()
  -- Draw pile background
  love.graphics.setColor(0.8, 0.8, 0.8, 0.5)
  love.graphics.rectangle("line", self.position.x, self.position.y, 71, 96)

  -- Draw cards in the pile
  for i, card in ipairs(self.cards) do
    card:draw()
  end
end
