# Swipe Jump

A physics-based mobile game where players draw lines to bounce a ball and hit targets.

## Game Description

Swipe Jump is a simple yet addictive iOS game where you control a bouncing ball by drawing temporary lines on the screen. The goal is to keep the ball in play while hitting targets to earn points. Be careful - if the ball hits the ground, it's game over!

## Gameplay Features

- **Simple Mechanics**: Draw lines with your finger to create bounce surfaces
- **Physics-Based**: Realistic bounce physics with proper collision detection
- **Target System**: Hit targets on the walls to earn bonus points
- **Sound Effects**: Satisfying audio feedback for bounces, hits, and game events
- **Endless Gameplay**: Keep playing as long as you can keep the ball bouncing

## Technical Features

- Built with SpriteKit and Swift
- Component-based architecture for better code organization:
  - `AudioManager`: Handles all game sounds
  - `TargetManager`: Manages targets and scoring
  - `LineManager`: Handles player-drawn lines
  - `GameElementFactory`: Creates game objects with proper physics
- Optimized for iOS devices
- Responsive touch controls

## How to Play

1. Launch the game
2. Swipe your finger across the screen to draw bounce lines
3. Try to hit the yellow targets on the walls for bonus points
4. Keep the red ball from touching the ground
5. When game over, tap to restart

## Development

The game is structured into several key components:

- `GameScene.swift`: Main game controller
- `AudioManager.swift`: Sound management
- `TargetManager.swift`: Target creation and handling
- `LineManager.swift`: Line drawing functionality
- `GameElements.swift`: Factory for creating game objects
- `GameConfig`: Constants for gameplay tuning

## Future Enhancements

- Power-ups and special abilities
- Multiple levels with increasing difficulty
- Online leaderboards
- Visual themes and customization options

## Credits

Created by Serhat Demir (2025) 