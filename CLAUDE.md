# Kiosk Jadwal Sholat — Musholla An-Nahl

Single-page kiosk/TV display app for Islamic prayer times (Surabaya, Indonesia).

## Stack

- Vanilla HTML/CSS/JS (no framework)
- **Adhan.js v4** — local prayer time calculation (ESM, loaded via dynamic import)
- **Aladhan API** — online prayer times source (`api.aladhan.com/v1/timings`)

## Location & Calculation

- Coordinates: `-7.4281, 112.699` (Musholla An-Nahl, Surabaya)
- Kemenag RI standard: Fajr angle 20°, Isha angle 18°
- Adhan.js: `CalculationMethod.Other()` with custom `fajrAngle`/`ishaAngle`, `Madhab.Shafi`
- API method: 11 (Singapore/Malaysia/Indonesia — matches Kemenag)

## Key Architecture

- **Single file**: all HTML, CSS, and JS in `index.html`
- **Dynamic import**: Adhan.js loaded via `import()` at startup (no UMD build exists for v4)
- **Data flow**: Aladhan API → Adhan.js local calc → hardcoded fallback
- **UI updates**: 1-second `setInterval` tick via `updateUI()`
- **Next prayer**: computed from obligatory prayers list, shows countdown (HH:MM:SS)
- **Iqama offsets**: Fajr +15min, Dhuhr/Asr +20min, Maghrib +5min, Isha +10min

## Prayer Order (display)

Subuh → Syuruq → Dzuhur → Ashar → Maghrib → Isya

## Testing

- Time simulation via URL param `?sim=2026-03-29T22:30:00` or `window.SIMULATED_NOW`
- 6-column prayer grid, single-row layout
- Kiosk: 98vw × 98vh, min-width 1400px recommended

## Common Tasks

- **Adjust iqama offsets**: edit `IQAMA_OFFSETS` object
- **Change location**: update `LATITUDE`/`LONGITUDE` and `FAJR_ANGLE`/`ISHA_ANGLE` constants
- **Add/remove prayers**: modify `PRAYER_NAMES_EN` and `PRAYER_NAMES_ID` arrays
