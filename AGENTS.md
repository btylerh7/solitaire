# AGENTS.md

## Build/Run

- lua main.lua - Run the game
- luajit main.lua - Run with LuaJIT
- lua -e "dofile("conf.lua")" - Load configuration

## Lint

- luac -l utils.lua - Check syntax
- luacheck --config .luarc.json --no-parallel utils.lua - Full lint

## Test

- lua -e "dofile("state.lua")" - Run state tests
- lua -e "dofile("events.lua")" - Run event tests

## Style

- 4 spaces indentation
- snake_case for variables
- CamelCase for classes
- error for fatal errors
- assert for validation
- Type hints in comments

## Rules

- No Cursor rules found
- No Copilot instructions found
