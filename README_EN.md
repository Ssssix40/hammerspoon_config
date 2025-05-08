# Hammerspoon Configuration

A powerful Hammerspoon configuration that provides window layout management and window positioning features.

## Features Overview

### Window Layout Management

Save and restore complete window layouts, including window positions, sizes, and z-order (stacking).

- **Save Current Layout**: Capture the position, size, and stacking order of all windows on screen
- **Restore Saved Layout**: Return windows to a previously saved layout state
- **Multiple Layouts Support**: Store up to 9 different layout configurations

### Window Positioning

Quickly adjust window position and size with hotkeys, supporting various preset layouts.

- **Basic Positions**: Fullscreen, left half, right half, centered with scaling
- **Corner Positions**: Top-left, top-right, bottom-left, bottom-right

## Hotkeys

### Window Layout Management

- `Cmd+Ctrl+Shift+N`: Save current window layout
- `Cmd+Shift+[1-9]`: Restore corresponding numbered layout (1 through 9)

### Window Positioning

Basic arrow keys (with `Cmd+Ctrl` as modifier):
- `←`: Position window to left half of screen
- `→`: Position window to right half of screen
- `↑`: Fullscreen window (100% of screen)
- `↓`: Center window at 85% of screen size

Corner positions (with `Cmd+Ctrl` as modifier):
- `U`: Position window to top-left corner
- `I`: Position window to top-right corner
- `J`: Position window to bottom-left corner
- `K`: Position window to bottom-right corner

## Configuration Structure

- `/init.lua`: Main configuration file, responsible for loading modules
- `/modules/layout.lua`: Window layout management module
- `/modules/windowManager.lua`: Window positioning module
- `/layouts/window_layouts.json`: Saved window layout data

## Customization

To customize the configuration, modify the corresponding module files:
- Change hotkeys: Edit the `init()` function in each module
- Adjust window size ratios: Edit the window handling functions in windowManager.lua
