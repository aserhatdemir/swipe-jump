# Swipe Jump

A 2D physics-based game for iOS where players guide a falling ball by creating bounce lines with swipes.

## Game Mechanics

- A ball falls under gravity from the top of the screen
- Players can draw lines by swiping on the screen
- The ball bounces when it hits these lines
- Six target objects (3 on each wall) award bonus points when hit by the ball
- Score increases by 1 point for each line drawn and 5 points for each target hit
- Game ends when the ball touches the ground at the bottom of the screen
- Ball bounces off the left, right, and top edges of the screen

## Scoring System

- **Basic Score:** 1 point for each line drawn
- **Bonus Score:** 5 points for each target hit
- **Strategy:** Aim for the targets on the walls to maximize your score
- **Challenge:** Each target can only be hit once per game

## Project Information

- **Project Name:** swipe-jump
- **Bundle ID:** com.demirstudio.swipe-jump
- **Technology:** SpriteKit, Swift

## Requirements

- Xcode 15.0 or later
- iOS 15.0 or later
- Swift 5.0

## Setup Instructions

1. Clone the repository
2. Open the project in Xcode
3. Add sound files:
   - Add `bounce.wav` to your project (sound when ball hits a line)
   - Add `gameover.wav` to your project (sound when game ends)
   - Add `target_hit.wav` to your project (sound when ball hits a target)
4. Build and run on an iOS device or simulator

## Game Elements

- **Ball:** Bouncy red ball with physics properties
- **Lines:** Player-created white lines that serve as temporary platforms
- **Targets:** Yellow circular objects on the walls that award bonus points
- **Walls:** Blue edges on the left and right sides that bounce the ball
- **Ground:** Red area at the bottom - touching it ends the game

## Physics Features

- Enhanced bounciness for a fun, dynamic gameplay
- Realistic physics simulation using SpriteKit
- Reduced gravity and increased restitution for better bounce effects
- Visual feedback when the ball hits lines or targets

## Controls

- Swipe anywhere on the screen to create a bounce line
- Tap the screen to restart after game over
- Long press (2 seconds) to enable debug mode (shows physics bodies and ball position)

## Notes for Developers

- The game is designed to work in portrait orientation only
- The physics simulation uses SpriteKit's built-in physics engine
- Line drawing is implemented using touch detection and SpriteKit's path-based shapes
- The ball and lines use physics bodies with appropriate collision masks
- Target objects use a Set to track which have been hit during the current game

## Planned Features

- Multiple levels with increasing difficulty
- Different ball types with unique physics properties
- Power-ups and special abilities
- High score tracking with Game Center integration
- Time-based challenges and achievements 