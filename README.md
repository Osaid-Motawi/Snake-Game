# Snake Game — Modern Edition

A modern take on the classic Snake game, built with **Lua** and **LÖVE2D**.
The project was developed for the **Lua Game Programming Assignment**.

## Project Overview
Guide the snake around the board, eat food, and earn points.
Your best score is saved and can be loaded the next time you play.

## Features
- Dark, modern interface with a custom menu and game-over overlay.
- Smooth-looking snake segments and a distinct head.
- Keyboard movement using the arrow keys or WASD.
- Food spawning on unoccupied cells.
- Wall and self-collision detection.
- Persistent high score between sessions.
- Mouse support for the menu and restart button.

## Requirements
- **LÖVE2D 11.x** to run the graphical game.
- **Lua 5.4 or newer** to run the standalone `<close>` example.

## Run the Game
1. Download or clone this repository.
2. Open a terminal in the project root (where `main.lua` is located).
3. Run the command appropriate for your system.

**Windows (PowerShell):**

```powershell
& "C:\Program Files\LOVE\love.exe" .
```

**macOS or Linux (when LÖVE is on PATH):**

```bash
love .
```


## Controls
| Key / Action | Result |
| --- | --- |
| Arrow keys / WASD | Move the snake |
| Enter | Start a game; restart after game over |
| Space | Start from menu; restart after game over; return to menu while playing |
| Backspace | Return to menu while playing |
| Escape | Close the application |
| Left mouse click | Use the start or restart button |

## Project Structure
```text
Snake-Game/
├── main.lua
├── gamestate.lua
├── entity.lua
├── vector2.lua
├── highscore.lua
├── love_highscore.lua
├── input.lua
├── events.lua
├── snake_game.lua
├── ui.lua
├── README.md
└── states/
    ├── menu_state.lua
    └── game_state.lua
```

## Assignment Concepts
- **Game State Manager:** separates the menu and playing states and delegates updates and drawing.
- **Entity Component Pattern:** stores position, movement, and renderer data in named components.
- **Vector2 Metamethods:** supports vector addition (`__add`), equality (`__eq`), and text output (`__tostring`).
- **Core Game Logic:** handles timed movement, random food, growth, collisions, and scoring.
- **Input Command Pattern:** maps keys to functions instead of hard-coding every action in the input callback.
- **Observer Pattern (Bonus):** uses subscriptions and emitted events for `food_eaten` and `game_over`.

## Modern Lua Feature: To-Be-Closed Variables

Lua 5.4 introduced the **`<close>` attribute** for variables that manage resources.
In `highscore.lua`, it is used with file handles returned by `io.open()`.
A to-be-closed file handle is automatically closed when its scope ends.
For example, `local file <close> = io.open("highscore.txt", "w")` opens a file for writing.
`save(score)` writes the score as text, and `load()` reads it back as a number.
**Compatibility note:** LÖVE2D 11.x uses LuaJIT, which does not parse Lua 5.4's `<close>` syntax.
Therefore the playable game uses `love_highscore.lua` and `love.filesystem` instead.
Both implementations remain in the repository for their different purposes.

## High Score Storage

The graphical game saves its record in LÖVE's application save directory.
It uses the identity `lua_snake_assignment` and a file called `highscore.txt`.
A new record is saved only when the current score beats the previous best.

## Verification and Submission

Check menu navigation, movement, food, collisions, restarts, and persistent scores.
Check that the bonus events are emitted when food is eaten or the game ends.
The final GitHub repository should contain all source files and this README.
Run the game locally before submitting the repository URL.
