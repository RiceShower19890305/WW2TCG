# World War II: TCG

**A World War II Trading Card Game** built by [Frozen Shard](http://www.frozenshard.com/games/ww2tcg/)  
Originally released on Steam (App ID `1019250`), iOS, Android, and Kongregate.

This repository was reverse-engineered from `MainGame.swf` using [JPEXS Free Flash Decompiler](https://github.com/jindrapetrik/jpexs-decompiler).

---

## Tech stack

| Layer | Technology |
|---|---|
| Language | ActionScript 3 (Adobe AIR desktop target) |
| Runtime | Adobe AIR 32 |
| Compiler | Apache Flex SDK 4.x |
| 2D framework | [Starling Framework](https://gamua.com/starling/) |
| UI components | [Feathers UI](https://feathersui.com/) |
| Animation | [GreenSock TweenMax](https://greensock.com/) |
| Backend / multiplayer | [GameSparks](https://www.gamesparks.com/) |
| Analytics | Google Analytics |
| Crypto | Hurlant crypto (TLS, RSA, AES) |
| WebSocket | net.gimite.websocket |
| Social | Facebook Graph API |
| Payments | Distriqt In-App Purchase + Steam In-App |

---

## Repository layout

```
WW2TCG/
├── src/                     ActionScript 3 source (1 510 files)
│   ├── MainGame.as          Entry point / document class
│   ├── Main.as              Core AIR application shell
│   ├── FSAirLibrary.as      Desktop/AIR-specific helpers
│   ├── SteamInAppsManager.as Steam purchase handler
│   ├── GameConfigInterface.as  Plugin interface
│   ├── com/
│   │   ├── fs/tcgengine/    Core TCG engine (model / view / controller)
│   │   ├── fs/wwiitcg/      WW2-specific resource overrides
│   │   ├── gamesparks/      GameSparks SDK (requests, responses, types)
│   │   ├── google/analytics/ Google Analytics AS3 SDK
│   │   ├── greensock/       TweenMax animation library
│   │   ├── gsolo/           AES encryption helpers
│   │   ├── hurlant/         Full TLS/RSA/AES crypto suite
│   │   ├── junkbyte/        AS3 in-game debug console
│   │   └── adobe/           Adobe serialization / URL utilities
│   ├── feathers/            Feathers UI component library
│   ├── starling/            Starling 2D framework
│   ├── embeddedConfig/      [Embed] stubs for binary game-data blobs
│   ├── mx/                  Flex runtime stubs (collections, binding)
│   ├── net/gimite/          WebSocket implementation
│   └── air/                 Adobe AIR SDK stubs
│
├── data/                    Game content (extracted from embedded blobs)
│   ├── units.json           4 656 unit cards
│   ├── attachments.json     1 389 attachment cards
│   ├── abilities.json       2 877 ability definitions
│   ├── actions.json         274 action cards
│   ├── quests.json          858 quests
│   ├── levels.json          201 PvE levels
│   ├── raids.json           18 raids  (+ raidLevels.json: 72 raid stages)
│   ├── dungeons.json        13 dungeons (+ dungeonLevels.json: 161 stages)
│   ├── maps.json            20 campaign maps
│   ├── packs.json           129 card packs
│   ├── editions.json        59 card editions
│   ├── heroes.json          22 hero definitions
│   ├── factions.json        5 factions
│   ├── rarities.json        8 rarity tiers
│   ├── boosts.json          18 boosts
│   ├── config.json          Global game config (all tuning knobs)
│   └── ...                  (49 JSON files total)
│
├── particles/               Particle effect configs (48 XML files)
│   ├── PackUnfoldXML.xml    Card-unpack effect
│   ├── ExplosionXML.xml
│   └── ...
│
├── assets/
│   ├── images/              Loading/splash backgrounds (multiple DPI variants)
│   └── fonts/               GameFont.ttf + Source Sans Pro
│
├── _assets/                 Raw embedded binary blobs (needed for compilation)
│
├── MainGame.swf             Original compiled SWF (reference / playable)
├── application.xml          Adobe AIR application descriptor
├── build.xml                Apache Ant build script
└── .gitignore
```

---

## Engine architecture

### Controller layer (`com.fs.tcgengine.controller`)
Single-responsibility manager singletons registered via `InstanceMng`:

| Class | Responsibility |
|---|---|
| `FSCardsMng` | Card definitions, deck management |
| `RulesMng` / `DefMng` | Combat rules, card definitions |
| `RaidsMng` | Raid logic (multi-player co-op PvE) |
| `DungeonsMng` | Dungeon logic (solo PvE) |
| `QuestsMng` | Quest tracking |
| `BoostsMng` | Consumable boost items |
| `GuildsMng` | Guild system |
| `AuctionsMng` | Card auction house |
| `TutorialMng` | Step-through tutorial |
| `ServerConnection` | GameSparks WebSocket connection |
| `FSCardAnimsMng` | Card animation sequencing |
| `FSFacebookPlugin` | Facebook Graph API integration |
| `FSInAppsManager` | In-app purchase abstraction |
| `FSSoundFXMng` | Sound effect management |

### Model layer (`com.fs.tcgengine.model`)
Pure data objects — `CardDef`, `UserData`, board state, battle engine.

### View layer (`com.fs.tcgengine.view`)
Starling `Sprite` subclasses organized by feature area:  
`board/`, `cards/`, `deckbuilder/`, `dungeons/`, `raids/`, `pvp/`, `guilds/`, `popups/`, etc.

### Screen flow
```
FSMenuScreen → FSMapScreen → FSBattleScreen
                          → FSDeckBuilderScreen
                          → FSShopScreen
                          → FSRaidsScreen
                          → FSDungeonsScreen
                          → FSPvPScreen
                          → FSAuctionsScreen
```

---

## Game content at a glance

| Data file | Count |
|---|---|
| Units | 4 656 |
| Attachments | 1 389 |
| Abilities | 2 877 |
| Actions | 274 |
| Quests | 858 |
| Levels | 201 |
| Raid stages | 72 |
| Dungeon stages | 161 |
| Card packs | 129 |
| Editions | 59 |
| Heroes | 22 |
| PvP bot decks | 75 |

Factions: **USA · Germany · USSR · Japan · (mixed)**  
Rarity tiers: Common · Uncommon · Rare · Epic · Legendary · Mega-Legendary · Ultra-Legendary · Uber-Legendary

---

## Building from source

### Prerequisites
- **Java 8+** (for the Ant build)
- **Apache Flex SDK 4.16** — download from [flex.apache.org](https://flex.apache.org/)
- **Adobe AIR SDK 32** — overlay on top of Flex SDK
- **Apache Ant 1.10+**

### Compile

```sh
# Copy ant.properties.example → ant.properties and set FLEX_HOME
cp ant.properties.example ant.properties

ant compile           # debug build → MainGame.swf
ant compile-release   # optimized build
ant package-air       # creates WW2TCG.air (needs a signing certificate)
ant clean
```

### embed path resolution
The `embeddedConfig/` stubs use `[Embed(source="/_assets/…")]`.  
The build sets `-source-path .` (project root) so `/_assets/` resolves to `<repo>/_assets/`.

---

## Third-party libraries bundled in `src/`

| Package | Library | License |
|---|---|---|
| `starling/` | Starling Framework | Simplified BSD |
| `feathers/` | Feathers UI | BSD |
| `com/greensock/` | GreenSock TweenMax (AS3) | GreenSock Standard License |
| `com/google/analytics/` | Google Analytics AS3 | Apache 2.0 |
| `com/hurlant/` | as3crypto | BSD |
| `com/junkbyte/console/` | AS3 Console | MIT |
| `net/gimite/websocket/` | as3websocket | MIT |
| `com/gamesparks/` | GameSparks AS3 SDK | GameSparks EULA |
| `com/adobe/` | Adobe serialization utils | Apache 2.0 |
| `mx/` | Apache Flex runtime stubs | Apache 2.0 |

---

## Credentials (historical — game is offline)

These were compiled into the original SWF and are no longer active.

| Service | Identifier |
|---|---|
| GameSparks API key | `q302667Npx4r` |
| GameSparks namespace | `wwiitcg` |
| Steam App ID | `1019250` |
| iOS App Store ID | `627392801` |
| Facebook App (prod) | `258546644291175` |
| Kongregate API key | `83bf0f60-885d-4a51-bb56-220b17446633` |

---

## Credits (from the game)

**Development:** Christian Gascons · Isidro Téllez · Marc Tormo · Eduard Cortés

**Acknowledgements:** Starling / Feathers Frameworks · IronBelly Studios · Riverette Music Label · GamesParks · ActionVFX · 3D model contributors on Sketchfab (CC BY-SA 4.0)

**Discord:** https://discord.com/invite/rMfaG32Btp  
**Facebook:** https://www.facebook.com/WorldWarTcg
