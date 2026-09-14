# World Clock for SketchyBar

## Status

Draft v1 implementation specification.

This document defines the product behavior, architecture, visual direction, implementation boundaries, and delivery plan for a World Clock companion to the existing SketchyBar setup.

The behavioral reference is Jason Fried's Omarchy World Clock as demonstrated in his two videos. The visual reference is the existing SketchyBar implementation in the dotfiles repository, especially its Catppuccin Mocha styling and Sky accent.

The goal is not to reproduce Jason's implementation technology or color palette. The goal is to reproduce the useful interaction model and product behavior in a way that feels native to the existing SketchyBar setup on macOS.

---

# 1. Product goal

Build an interactive World Clock for SketchyBar.

Clicking the existing **time item** in SketchyBar opens a borderless floating panel anchored below that item.

The panel shows a configurable list of cities with:

- current local time
- local date
- timezone abbreviation
- relative timezone difference from the home city
- current temperature
- current weather condition
- a visual 24-hour sunrise/daylight/sunset timeline
- contextual local greetings
- interactive time scrubbing
- city search, add, and remove actions
- an interactive globe

The globe is part of v1.

The existing **date/calendar item is out of scope** and must remain unchanged.

---

# 2. Existing SketchyBar behavior to preserve

The current date and time have already been split into independent SketchyBar items.

Example:

```text
Fri 11 Sep   •   03:55 PM
```

Requirements:

- The date item remains unchanged.
- The date item has no World Clock responsibility.
- Only the time item toggles the World Clock.
- The World Clock should anchor to the current on-screen position of the time item.
- Existing SketchyBar display-positioning behavior must continue to work.
- The World Clock integration must not require restructuring unrelated SketchyBar items.

---

# 3. Architecture

Use:

- SketchyBar + SbarLua for the bar item
- Tauri for the companion macOS window
- React
- TypeScript
- CSS
- SVG, Canvas, or WebGL where appropriate
- Rust only for Tauri/native integration and window management

Do not use:

- Swift
- SwiftUI
- Qt
- QML
- Electron
- a Chromium bundle
- native SketchyBar popups for the full World Clock UI

The World Clock should be a small companion application controlled from SketchyBar.

Conceptually:

```text
SketchyBar time item
        |
        | click
        v
World Clock toggle command
        |
        v
Tauri window
        |
        +-- React UI
        +-- city cards
        +-- daylight timelines
        +-- city search
        +-- time scrubbing
        +-- interactive globe
```

The Tauri window should be:

- borderless
- visually lightweight
- always positioned relative to the SketchyBar time item
- hidden when toggled off
- hidden when appropriate after losing focus, unless that creates usability problems during interaction
- not represented as a normal application window in everyday use if Tauri/macOS allows this cleanly

The implementation should keep native/Rust logic minimal.

---

# 4. Repository placement

Preferred location:

```text
config/sketchybar/
├── ...
├── items/
│   ├── date.lua
│   ├── clock.lua
│   └── ...
└── world-clock/
    ├── package.json
    ├── src/
    │   ├── components/
    │   ├── hooks/
    │   ├── lib/
    │   ├── types/
    │   ├── styles/
    │   └── main.tsx
    └── src-tauri/
```

The World Clock exists specifically as a SketchyBar companion, so keeping it inside `config/sketchybar/` is preferred unless there is a strong implementation reason not to.

---

# 5. Visual direction

Use the existing SketchyBar visual language rather than copying Jason Fried's colors literally.

Required theme:

**Catppuccin Mocha**

Primary accent:

**Sky**

The World Clock should look like an extension of the existing SketchyBar configuration.

Use the existing preferred Nerd Font where appropriate.

The UI should feel:

- compact
- dark
- restrained
- slightly translucent where appropriate
- rounded
- consistent with the existing bar pills
- information-dense without looking crowded

Avoid excessive decoration.

---

# 6. Catppuccin Mocha color usage

Use the existing SketchyBar palette as the source of truth.

At minimum, the companion UI will need the full set of colors required by the design.

Suggested semantic mapping:

```text
Panel background       Base or Mantle
Card background        Surface0
Card hover             Surface1
Primary text           Text
Secondary text         Subtext0
Muted text             Overlay0
Primary accent         Sky
Selected marker        Sky
Home marker            Sky
Daylight               Yellow
Sunrise / sunset       Peach
Positive / clear       Green
Night timeline         Surface0 / Surface1
Border                  Surface1 / Surface2
```

Do not use Mauve as the main accent unless the existing SketchyBar theme changes later.

Do not duplicate unrelated color values in multiple places if a simple shared source can be created.

A small generated CSS variables file is acceptable.

---

# 7. Main panel behavior

Clicking the SketchyBar time item toggles the World Clock.

Opening behavior:

- Open directly below the time item.
- Horizontally align the panel with the time item.
- Keep the panel fully within the active display bounds.
- If the clock item moves because of display changes, calculate its actual position instead of assuming a fixed right-side location.
- Recalculate placement when opening.
- Support multi-monitor setups.

Closing behavior:

- Clicking the time item again closes the panel.
- Escape should close the panel.
- Clicking outside may close the panel if this does not interfere with drag interactions.
- Do not close while the user is actively dragging the globe or time scrubber.

The panel should not steal focus more aggressively than necessary.

---

# 8. Home location

The app needs a configured home city.

The home city is the reference for:

- the header
- relative timezone offsets
- "Tomorrow" and future "Yesterday" calculations
- the globe home marker

Initial implementation may use a static configuration value rather than device geolocation.

The data model should allow the home city to be changed later.

Required home-city fields:

```text
name
country
latitude
longitude
iana_timezone
locale
```

Do not require automatic geolocation in v1.

---

# 9. Header

The top of the World Clock panel displays the user's current home time.

Example:

```text
It's 3:55 PM here in São José dos Campos
```

When the selected instant is not the current time, append the relative shift from now.

Example:

```text
It's 5:39 PM here in São José dos Campos  +1h 44m
```

or:

```text
It's 2:11 PM here in São José dos Campos  -1h 44m
```

Below or near this line, show the title:

```text
World  🌎  Clock
```

The title globe should have subtle animation.

The animation should remain lightweight and should not consume noticeable CPU while the panel is open.

---

# 10. Saved city list

The main list displays configured cities.

Each city is represented by a card.

Each card contains:

```text
City + weather                 Local time
Date / greeting                TZ + relative offset

<------------- daylight timeline ------------>
```

---

# 11. City name

Display the friendly city name prominently.

Examples:

```text
Chicago
Auckland
Copenhagen
Tokyo
New York
```

---

# 12. Local time

Display each city's local time prominently on the right.

Requirements:

- respect the selected 12h/24h format used by the implementation
- if the existing SketchyBar time uses 12h, v1 may use 12h consistently
- minutes must update live
- all city times represent the same absolute instant

Seconds are not required.

---

# 13. Local date

Display the local date under the city name.

Example:

```text
Fri Sep 11
```

When the city is on the next calendar day relative to the home city:

```text
Sat Sep 12 · Tomorrow
```

Observed requirement:

- support `Tomorrow`

Optional future enhancement:

- `Yesterday`

Do not implement `Yesterday` unless it falls out naturally from the date-relative logic or is trivial.

---

# 14. Timezone abbreviation

Display the effective timezone abbreviation for the selected instant.

This must reflect daylight-saving rules for that date.

Do not hard-code abbreviations.

Use proper timezone-aware date handling.

---

# 15. Relative timezone difference

Show each city's offset relative to the home city.

This should be calculated from the effective offsets at the selected instant, not from a fixed static value.

This matters because daylight-saving differences can change throughout the year.

---

# 16. Weather

Display:

- current temperature
- current weather-condition icon

Requirements:

- cache weather data
- do not refresh weather every minute
- tolerate temporary network/API failure
- render the rest of the World Clock even if weather is unavailable
- avoid requiring an API key if a reliable free source can provide the required data

Preferred first candidate:

- Open-Meteo

Keep the weather integration behind a small service interface so it can be replaced later.

---

# 17. Daylight timeline

Each city card contains a visual 24-hour timeline.

The timeline communicates:

- night
- sunrise
- daylight
- sunset
- night
- currently selected local time

The daylight section should use Catppuccin Yellow or another theme-consistent daylight color.

Night should use muted surface colors.

---

# 18. Current-time marker

Place a circular marker at the selected local time on the 24-hour timeline.

Use the primary Sky accent for the marker unless a different state needs emphasis.

The marker moves as time changes.

During time scrubbing, every city's marker updates synchronously.

---

# 19. Sunrise and sunset markers

Show subtle sunrise and sunset markers on the timeline.

The interaction should follow Jason's design:

- markers become more noticeable during hover or active interaction
- sunrise and sunset positions correspond to the saved city's coordinates and selected date

Use Catppuccin Peach for sunrise/sunset emphasis.

---

# 20. Sunrise / sunset tooltip

Hovering the sunrise or sunset marker displays a compact tooltip.

Examples:

```text
Sunrise 6:21 AM
Sunset 8:07 PM
```

---

# 21. Solar calculations

Use a proven library or well-tested astronomical implementation for sunrise and sunset.

Do not hand-roll approximate solar calculations unless there is no reasonable small dependency.

---

# 22. Card hover state

Hovering a city card should:

- slightly change the card background
- expose contextual controls
- replace the normal date line with a localized greeting when available
- expose the remove action
- make sunrise/sunset markers clearer

Keep hover effects subtle.

---

# 23. Localized greetings

When hovering a city card, replace the date line with a greeting appropriate to the city's local language and current time of day.

Observed examples from Jason's implementation:

```text
Chicago     -> Good morning
Auckland    -> Pō mārie
Copenhagen  -> Godaften
New York    -> Good evening
```

Requirements:

- greeting is based on selected local time
- greeting language is associated with the city/locale
- returning the pointer away from the card restores the date
- greetings are a personality feature, not a translation framework

A small curated mapping is acceptable.

---

# 24. Remove city

On card hover, show a small remove control in the top-right area.

Clicking it removes the city immediately.

Requirements:

- update the UI immediately
- persist the updated city list
- do not require confirmation in v1

---

# 25. Time travel / time scrubbing

The daylight timeline is draggable.

Dragging horizontally changes the selected absolute instant.

This is a global operation.

All cities update to the same selected instant.

During scrubbing, update in real time:

- home-city header time
- delta from now
- every city local time
- every city date
- timezone abbreviation if necessary
- relative timezone offsets
- `Tomorrow` state
- daylight marker positions
- day/night state
- localized greeting if currently shown

The cursor should clearly communicate horizontal dragging.

---

# 26. Selected instant model

Maintain one global selected instant.

Do not store separate independent times per city.

---

# 27. Return to now

Preferred v1 behavior:

- release the drag and remain at the selected instant
- show a small explicit `Now` action while time traveling
- clicking `Now` returns to live mode

Do not automatically snap back immediately on pointer release.

---

# 28. Add city

At the bottom of the list display:

```text
+ Add a city
```

Clicking it opens an inline search interface.

Do not open a separate macOS modal.

---

# 29. City search

Search field placeholder:

```text
Search cities...
```

Requirements:

- search as the user types
- results update immediately
- support common city-name searches
- results must include timezone metadata

Each result should include:

```text
City name
IANA timezone
UTC offset
```

---

# 30. City dataset

Use a local searchable city dataset if practical.

Required fields:

```text
id
name
country
latitude
longitude
iana_timezone
locale
```

Do not query a remote geocoding API for every keystroke if a compact local dataset can provide the required behavior.

---

# 31. Add city behavior

Selecting a search result should:

- add the city to the saved list
- persist it
- close or clear the search state
- render weather and solar data when available
- avoid duplicates

---

# 32. Persistence

Persist at minimum:

```text
home city
saved cities
```

Use the simplest durable local mechanism that fits Tauri well.

A small JSON config file is preferred over a database.

---

# 33. Globe view

The interactive globe is mandatory in v1.

Required features:

- spherical globe
- simplified continent outlines
- latitude/longitude grid
- city labels
- city markers
- home marker
- selected city marker
- pointer-drag rotation
- visual consistency with Catppuccin Mocha

Do not use a photorealistic map.

Do not use Google Maps.

Do not use Mapbox unless there is a compelling reason.

---

# 34. Globe rendering approach

First preference:

- custom lightweight SVG/Canvas/WebGL implementation

Second preference:

- a focused globe library with a small integration surface

Potential candidates may include:

- Three.js
- globe.gl

Codex should evaluate whether a small custom projection is simpler than adding a globe library.

---

# 35. Globe appearance

Suggested styling:

```text
Ocean / sphere        Base / Mantle
Continents            Surface1 / Subtext
Grid                  Overlay0 with low opacity
Normal markers        Subtext0
Home marker           Sky
Selected marker       Sky outline / ring
Labels                Text / Subtext0
```

---

# 36. Globe interaction

Required:

- drag horizontally and vertically to rotate
- maintain smooth interaction
- do not accidentally close the window while dragging
- highlighted city should remain clear during rotation

Not required:

- pinch zoom
- scroll-wheel zoom
- terrain
- country borders

---

# 37. Home marker

Display the home city using a distinct marker.

Use Sky.

---

# 38. Selected city marker

The currently selected or highlighted city should have a distinct ring or marker state.

---

# 39. Globe city labels

The globe may display more cities than the saved city list.

Use a curated dataset.

Do not render thousands of city labels at once.

---

# 40. Jump to a city

The globe view should expose a search affordance similar to:

```text
Jump to a city
```

Selecting a city should:

- rotate/focus the globe toward that city
- highlight the city
- not automatically add it to the saved list unless explicitly requested

---

# 41. View switching

The user must be able to switch between:

- city-list view
- globe view

The title globe may act as the switch, matching Jason's behavior.

---

# 42. Live updates

When not time traveling:

- update visible clocks every minute
- update the header every minute
- update markers every minute

Weather refresh should be much less frequent.

---

# 43. Data model

Suggested city model:

```ts
type City = {
  id: string
  name: string
  country: string
  latitude: number
  longitude: number
  timezone: string
  locale: string
}
```

Global state:

```ts
type WorldClockState = {
  homeCity: City
  savedCities: City[]
  selectedInstant: Date
  isTimeTraveling: boolean
  hoveredCityId: string | null
  selectedGlobeCityId: string | null
  activeView: "list" | "globe"
}
```

---

# 44. Date/time libraries

Use a modern timezone-aware JavaScript library or platform APIs if sufficient.

The implementation must correctly handle:

- IANA timezones
- daylight saving time
- calendar-day differences
- timezone abbreviation
- offset differences for arbitrary selected dates

Do not use manual UTC arithmetic for timezone logic.

Potential options:

- Temporal if runtime support is sufficient
- `date-fns-tz`
- Luxon

Prefer the smallest dependable solution.

---

# 45. Failure states

Weather failure:

- render city information normally
- omit or mute weather
- no modal errors

Solar failure:

- render a neutral timeline
- still show current-time position
- omit sunrise/sunset markers

The core clock must remain usable offline except for fresh weather.

---

# 46. Performance

Targets:

- panel appears quickly after clicking the time item
- city-list interactions remain responsive
- globe dragging remains smooth
- idle CPU usage remains low
- no continuous high-frequency animation loops
- no unnecessary network polling

Pause expensive rendering when the panel is hidden if possible.

---

# 47. Out of scope for v1

Do not add unless explicitly requested:

- calendar integration
- date-item click behavior
- Google Calendar
- meeting scheduling
- automatic device geolocation
- home-city settings UI
- Celsius/Fahrenheit settings UI
- 12h/24h settings UI
- city reorder by drag-and-drop
- notifications
- alarms
- timers
- system tray icon
- dock UI
- arbitrary themes
- cloud sync
- account system
- analytics
- telemetry

The date item is intentionally reserved for a future implementation.

---

# 48. SketchyBar integration

The existing time item should gain a click action that toggles the companion app.

The integration should be minimal.

Prefer a small stable command that SketchyBar can invoke.

---

# 49. Popup positioning

This is a high-risk integration area and must be proven early.

Requirements:

- work when clock is centered
- work when clock is right aligned
- work on multiple displays
- keep panel inside screen bounds
- account for Retina scaling correctly
- open below the bar

Do not hard-code x/y coordinates.

---

# 50. Window behavior

Desired macOS behavior:

- borderless
- no title bar
- no traffic-light buttons
- rounded corners
- transparent/controlled background
- floating above normal windows as appropriate
- no Dock presence during normal usage if Tauri can support it cleanly
- smooth show/hide
- no launch splash screen

---

# 51. Dependency philosophy

Keep dependencies small.

Prefer:

- built-in browser APIs
- focused libraries
- local datasets
- OS WebKit through Tauri

Avoid:

- Electron
- Chromium
- large map SDKs
- huge UI component frameworks
- unnecessary state-management libraries

---

# 52. Suggested React component structure

```text
App
├── WorldClockPanel
│   ├── Header
│   ├── ListView
│   │   ├── CityCard
│   │   └── AddCity
│   └── GlobeView
│       ├── Globe
│       └── CitySearch
├── Tooltip
└── NowButton
```

---

# 53. Suggested service boundaries

```text
lib/
├── time.ts
├── solar.ts
├── weather.ts
├── cities.ts
├── greetings.ts
└── persistence.ts
```

---

# 54. Testing expectations

Priority tests:

- timezone conversion
- DST-sensitive relative offsets
- `Tomorrow` calculation
- time-travel delta formatting
- timeline position calculation
- sunrise/sunset marker position
- city deduplication
- persistence serialization
- greeting time-of-day selection

Include dates where home and destination cities switch DST on different dates.

---

# 55. Implementation strategy

Do not build the whole feature in one Codex task.

Implement in vertical slices.

Every merged slice must leave SketchyBar working.

Avoid long-lived broken intermediate states.

---

# 56. Phase 0: technical spike

Before the real implementation, prove the highest-risk assumptions.

Build the smallest possible disposable or minimal implementation that proves:

1. Tauri runs correctly on the Mac.
2. SketchyBar can toggle the Tauri window.
3. The window can be borderless.
4. The window can anchor below the actual clock item.
5. The window behaves correctly on the current display setup.
6. A basic interactive globe can render and rotate smoothly in macOS WebKit.

Acceptance criteria:

- Clicking the time pill opens a small test window below it.
- Clicking again closes it.
- The date pill does nothing.
- The test window can render a simple rotatable sphere/globe without obvious lag.

Do not proceed to the full implementation until this spike is accepted.

---

# 57. Phase 1: production shell

Scope:

- repository structure
- Tauri app
- React app
- Catppuccin Mocha theme
- borderless panel
- proper toggle behavior
- actual positioning
- static header
- static mock city cards

Acceptance criteria:

- World Clock visually belongs to the current SketchyBar.
- It opens from the time item only.
- Date item remains unchanged.
- It positions correctly.
- It can be opened and closed repeatedly without duplicate windows/processes.

---

# 58. Phase 2: real timezone data

Scope:

- home city
- saved cities
- local time
- local date
- timezone abbreviation
- home-relative offset
- live minute updates
- `Tomorrow`

Acceptance criteria:

- Every city shows correct time for the same instant.
- DST is respected.
- Home-relative offsets are correct.
- Time updates without reopening the panel.

---

# 59. Phase 3: daylight timeline

Scope:

- sunrise
- sunset
- daylight segment
- night segment
- current-time marker
- sunrise/sunset markers
- tooltips

Acceptance criteria:

- Timeline corresponds to each city's local day.
- Current-time marker is positioned correctly.
- Marker updates when time advances.
- Sunrise/sunset tooltip displays correct local time.

---

# 60. Phase 4: weather

Scope:

- temperature
- condition
- icon
- caching
- failure fallback

Acceptance criteria:

- Weather appears for saved cities.
- Weather failure does not break the clock.
- Reopening the panel does not cause unnecessary repeated API calls.

---

# 61. Phase 5: time travel

Scope:

- draggable timeline
- selected global instant
- synchronous city updates
- delta from now
- explicit return to now

Acceptance criteria:

- Dragging any timeline changes all cities consistently.
- Header displays positive/negative delta from now.
- Dates and `Tomorrow` update correctly.
- Releasing the pointer preserves the selected instant.
- `Now` restores live mode.

---

# 62. Phase 6: city management

Scope:

- Add a city
- search interface
- city dataset
- result metadata
- add
- remove
- deduplication
- persistence

Acceptance criteria:

- Search results appear while typing.
- Selecting a result adds the city.
- Removed cities stay removed after restart.
- Added cities remain after restart.
- Duplicate cities cannot be added.

---

# 63. Phase 7: interaction polish

Scope:

- card hover
- localized greetings
- subtle hover controls
- remove button reveal
- refined sunrise/sunset marker hover
- tooltip polish

Acceptance criteria:

- Date changes to greeting on hover.
- Greeting reflects local time-of-day.
- Leaving hover restores date.
- Controls are discoverable without cluttering the default state.

---

# 64. Phase 8: globe

Scope:

- sphere
- continents
- grid
- labels
- saved-city markers
- home marker
- selected marker
- rotation
- globe/list switching
- jump-to-city search

Acceptance criteria:

- Globe is interactive and smooth.
- Home city is visually distinct.
- Selected city is visually distinct.
- Saved cities can be identified.
- Dragging rotates the globe.
- Jump-to-city focuses/highlights the selected city.
- Globe uses Catppuccin Mocha styling.

Because the globe is mandatory in v1, v1 is not complete until this phase is done.

---

# 65. Phase 9: final polish

Scope:

- animated title globe
- spacing
- transitions
- corner radii
- translucency
- edge cases
- multi-monitor verification
- startup behavior
- install/update instructions
- cleanup unused spike code

Acceptance criteria:

- app feels integrated with the existing bar
- no obvious visual mismatch
- no unnecessary background CPU usage
- no stale helper processes after repeated toggling
- all major interactions work across multiple opens/closes

---

# 66. Definition of v1 complete

v1 is complete only when all of the following work:

- time pill toggles World Clock
- date pill is untouched
- borderless Tauri panel
- correct dynamic positioning
- Catppuccin Mocha + Sky styling
- home city
- saved city list
- live local times
- dates
- timezone abbreviations
- relative offsets
- `Tomorrow`
- weather
- daylight timelines
- sunrise/sunset markers
- sunrise/sunset tooltips
- localized greetings
- remove city
- add city
- search city
- persistence
- global time scrubbing
- delta from now
- return to now
- interactive globe
- globe rotation
- home marker
- selected marker
- city labels
- jump-to-city
- smooth live updates

---

# 67. Codex working rules

When using Codex to implement this project:

1. Read this specification before changing code.
2. Inspect the existing SketchyBar implementation before proposing integration changes.
3. Preserve existing behavior unless this spec explicitly changes it.
4. Do not refactor unrelated SketchyBar files.
5. Keep the date item completely out of scope.
6. Implement one phase at a time.
7. Before each phase, propose the exact files that will change.
8. After each phase:
   - summarize what changed
   - describe how to test it manually
   - list any deviations from this specification
9. Do not silently add product features.
10. Ask before introducing a large dependency.
11. Prefer small, readable dependencies.
12. Keep Rust code minimal.
13. Keep the main product logic in TypeScript where practical.
14. Preserve Catppuccin Mocha and Sky as the visual source of truth.
15. Do not replace existing bar styling with Jason Fried's color palette.
16. Do not mark v1 complete without the globe.

---

# 68. First Codex task

Start with Phase 0 only.

Suggested prompt:

```text
Read `world-clock-spec.md` and inspect the existing SketchyBar implementation.

Implement only Phase 0, the technical spike.

Before changing code, explain:
1. how you plan to toggle a Tauri window from the existing time item,
2. how you plan to determine the time item's screen coordinates,
3. how you plan to create a borderless floating Tauri window,
4. what you will use for the minimal interactive globe spike,
5. which dependencies you need to add.

Do not implement the production World Clock yet.
Do not modify the date item.
Do not refactor unrelated SketchyBar files.

After I approve the plan, implement the spike.
```

---

# 69. Intentional differences from Jason's implementation

This project intentionally differs in these areas:

- Catppuccin Mocha instead of Jason's palette
- Sky as the primary accent
- macOS + SketchyBar rather than Omarchy
- Tauri + React + TypeScript rather than Quickshell
- existing date item remains separate and untouched
- existing time item is the sole World Clock trigger
- popup anchors below a horizontal SketchyBar item
