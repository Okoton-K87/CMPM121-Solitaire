require "vector"

Card = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

function Card:new(xPos, yPos, suit, rank, faceUp)
  local card = setmetatable({}, {__index = Card})
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(71, 96) -- match your actual image sizes if needed
  card.state = CARD_STATE.IDLE
  
  card.suit = suit
  card.rank = rank
  card.faceUp = faceUp or false -- default to face down

  if faceUp then
    card.image = love.graphics.newImage("cards/" .. suit .. "/" .. rank .. "_" .. suit .. ".png")
  else
    card.image = love.graphics.newImage("cards/card back/card_back.png")
  end

  card.frontImage = love.graphics.newImage("cards/" .. suit .. "/" .. rank .. "_" .. suit .. ".png")
  card.backImage = love.graphics.newImage("cards/card back/card_back.png")
  
  return card
end

function Card:update()
  -- (You can expand this later if needed)
end

function Card:draw()
  love.graphics.setColor(1, 1, 1, 1)
  
  local image = self.faceUp and self.frontImage or self.backImage
  
  -- Draw the image scaled to fit 71x96
  local scaleX = self.size.x / image:getWidth()
  local scaleY = self.size.y / image:getHeight()
  
  love.graphics.draw(image, self.position.x, self.position.y, 0, scaleX, scaleY)
end


function Card:checkForMouseOver(grabber)
  if self.state == CARD_STATE.GRABBED then
    return
  end

  local mousePos = grabber.currentMousePos
  local isMouseOver =
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y

  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
end

function Card:flip()
  self.faceUp = not self.faceUp
end
