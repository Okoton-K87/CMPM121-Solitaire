# CMPM 121 Solitaire Project

## Project Description

This project implements Klondike Solitaire (Hard Mode), developed in Lua using the LÖVE2D framework.  
Players can move cards between piles, draw three cards at a time from the deck, and always have the top card of each tableau pile face up.

---

## Programming Patterns Used

- **Class Pattern (via Lua tables and metatables)**  
  Used to create `Card`, `Grabber`, and `Pile` objects, each with their own properties and methods.  
  This helped keep code organized and object-oriented even in Lua.

- **State Tracking**  
  Each card keeps track of its own `state` (idle, mouse over, grabbed) and `faceUp` status.  
  This allowed for easy control over what the player can interact with.

- **Separation of Concerns**  
  Different files handle different responsibilities:
  - `card.lua` manages card behavior.
  - `grabber.lua` manages mouse interaction.
  - `pile.lua` manages card piles.
  - `main.lua` initializes and runs the game.  
  Keeping things separated made debugging and development easier.

---

## Feedback from Classmates

- **Person 1:**  
  Suggested adding a check to only allow grabbing face-up cards.  
  ➔ I updated the grab logic to only grab cards that are `faceUp == true`.

- **Person 2:**  
  Recommended flipping the next card in the pile after moving the top card away.  
  ➔ I updated the release logic to flip the new top card in tableau piles automatically.

- **Person 3:**  
  Pointed out that the initial card dealing should be randomized for a real Solitaire feel.  
  ➔ I implemented a shuffle of the full deck before dealing cards into tableau and deck piles.

---

## Postmortem

**What went well:**
- Organizing code into multiple files using classes made the project more manageable.
- Setting up the initial piles and shuffling cards worked smoothly.
- Mouse grabbing and moving cards felt natural after polishing.

**What I would improve next time:**
- I would add stricter game rules (e.g., only allowing moves onto valid cards) to make it a true full Solitaire game.
- I might have used a finite state machine pattern for handling card interactions even more cleanly.

---

## Assets Used

- Card sprites:  
  [https://natomarcacini.itch.io/card-asset-pack](https://natomarcacini.itch.io/card-asset-pack)

I did not add any fonts, music, SFX, or background images because the assignment did not require them.

---
