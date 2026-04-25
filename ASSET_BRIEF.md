# Helix Jump — sprite brief

**Strategy**: generated
**Palette**: sunset_brasil

## Sprites required

- ball.png 36x36 yellow ball
- disc_segment_safe.png 90x16 green/yellow segment with bevel
- disc_segment_deadly.png 90x16 red segment with spikes hint
- tower_pole.png 20x800 dark vertical pole

## How to generate

1. Implement `scripts/gen_sprites.py` to draw each sprite via PIL.
2. Use AppColors.primary / secondary / accent / background / text — derive
   the actual hex by reading `lib/ds/app_colors.dart` (already generated
   from palette `sunset_brasil`).
3. Output PNGs to `assets/sprites/` matching the names above.
4. Run `python3 scripts/gen_sprites.py` from the repo root.

## Composition rules

- Every sprite must be ON-THEME (`sunset_brasil`). No alien colors.
- Use gradients + soft shadows where appropriate (not flat fill).
- Transparent background (RGBA) on every PNG.
- Anti-aliased edges (PIL's `draw.ellipse` etc handle this).
- Keep filesizes small (each sprite < 30KB).
