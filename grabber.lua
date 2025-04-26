require "vector"

Grabber = {}

function Grabber:new()
  local grabber = {}
  local metadata = {__index = Grabber}
  setmetatable(grabber, metadata)

  grabber.previousMousePos = nil
  grabber.currentMousePos = nil
  grabber.grabPos = nil
  grabber.heldObject = nil
  
  return grabber
end

function Grabber:update()
  self.currentMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )

  local isMouseDown = love.mouse.isDown(1)

  if isMouseDown and not self.wasMouseDown then
    self:grab()
  end

  if not isMouseDown and self.wasMouseDown then
    self:release()
  end

  self.wasMouseDown = isMouseDown

  if self.heldObject then
    self.heldObject.position = self.currentMousePos
  end
end

function Grabber:grab()
  self.grabPos = self.currentMousePos
  print("GRAB - " .. tostring(self.grabPos))

  for _, card in ipairs(cardTable) do
    local m = self.currentMousePos
    local c = card

    -- 🔥 Added faceUp check here
    if c.faceUp and
       m.x > c.position.x and m.x < c.position.x + c.size.x and
       m.y > c.position.y and m.y < c.position.y + c.size.y then

      self.heldObject = card
      card.state = CARD_STATE.GRABBED
      break
    end
  end
end

function Grabber:release()
  print("RELEASE - ")
  if self.heldObject == nil then
    return
  end
  
  local isValidReleasePosition = self.currentMousePos.x >= 0 and self.currentMousePos.x <= 960 and
                                 self.currentMousePos.y >= 0 and self.currentMousePos.y <= 640
  
  if not isValidReleasePosition then
    self.heldObject.position = self.grabPos
  end
  
  self.heldObject.state = 0
  self.heldObject = nil
  self.grabPos = nil
end
