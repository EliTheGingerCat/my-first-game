### Archival

This project will be archived after game jam results are released.

# My First Game

A game made for BloxCode Game Jam season 3.

## Table of Contents

- [Details](#details)
- [Bugs](#bugs)
- [Missing Features](#missing-features)
- [Dependencies](#dependencies)
- [Development](#development)
- [Funny Commits](#funny-commits)
- [License](#license)

## Details

### Game jam

It is a game jam specifically for Roblox games.

Theme: "Everything Breaks".

Time: 14 days

Discord server link: https://discord.gg/uRjW8ny9qb

### This submission

Developers: [@EliTheGingerCat](https://github.com/EliTheGingerCat), [@DarkenedRing](https://github.com/DarkenedRing)

Time: We only really worked on it for 8 days.

Game link: https://www.roblox.com/games/8515170099

## Bugs

Known bugs (that are not intentional):

- The bots stutter. No idea why

- The bots seem to teleport at certain parts in the obby. This is because the pathfinding could not find any a path through these jumps, so we added [pathfinding links](https://create.roblox.com/docs/reference/engine/classes/PathfindingLink). These were used to simulate jumping by teleporting the bots in an arc. This hardcoded-jump probably could have been improved if there was more time. For example, the bots could have been moved a little every frame to make the movement much smoother, and `sine` could be utilised to make the arc more accurate to real life (around the peak of the jump, velocity is closest to 0).

- When the bots are trying to climb the hill up to the train, they teleport to the top, then seem to jump down, then teleport back up. There is a pathfinding link, so same behaviour as above. However, in order to make the bots be able to complete the in reverse to get back to Valley Town, the links are flipped to move the bots in the opposite direction. Unfortunately, this oversight means that in the beginning, bots *would* be simulated jumping from the bottom to the top of the mountain, but then it is flipped, so when they actually get there, they move from top to bottom.

- The characters get stuck at the train stop and do not move with the train.

## Missing Features

Features that we would have liked to add if time permitted:

- Two different dialogue texts trying to overwriting each other at the same time.

- Audio.

- Audio corruption (pitch, volume, maybe randomly playing (a character could ask "What was that noise?!")).

- Text in the ending. Would be nice to show the game's title and credits.

## Dependencies

### Main

- [React Lua](https://react.luau.page/)
- [Signal (sleitnick)](https://sleitnick.github.io/RbxUtil/api/Signal/)

### Development

- [Rojo](https://react.luau.page/)

### Development tools

These are not necessary for development, but help.

- [Rokit](https://github.com/rojo-rbx/rokit): Package management.
- [Lune](https://lune-org.github.io/docs): Build the test place. Most would say this *is* necessary for development, but in this case, there was barely any testing for the game. Plus, you could fully just use Rojo for this.
- [Luau Language Server](https://github.com/JohnnyMorganz/luau-lsp) (Luau LS): Luau intellisense.

## Development

Only Rokit and Luau LS need to be installed manually.

Install development dependencies: `rokit install`

Regenerate sourcemap: `rojo sourcemap -o sourcemap.json`

Regenerate sourcemap and watch for changes: `rojo sourcemap -o sourcemap.json --watch`

Build: `rojo build -o build.rbxl`

View Lune scripts: `lune list`

Build test place: `lune run build_test`

## Funny Commits

These are funny due to the commit description.

Ordered ascending by date.

- https://github.com/EliTheGingerCat/my-first-game/commit/b1d374bbad0ec6f253b692f1ba73f8989c39c42f
- https://github.com/EliTheGingerCat/my-first-game/commit/c8ceac3fcb2386bbe3a47426313935262a730501
- https://github.com/EliTheGingerCat/my-first-game/commit/128ae778633db17135cd9600ee29f7431a2ac670 - more interesting than funny

## License

This project is licensed under the MIT License. See [`LICENSE.txt`](./LICENSE.txt).

This is an entire (slightly unfinished) Roblox game so it is feels weird to say that you can copy a finished project, but honestly I do not care if you copy exactly and publish on your account. Assuming you follow the terms of the license, of course.

Public attribution would be nice!