"""Generate Helix Jump sprites on-theme with `sunset_brasil` palette.

Sprites:
  - ball.png 40x40 — bouncing ball with face, sphere shading
  - platform_safe.png 90x30 — green-amber safe pad with rim highlight
  - platform_dead.png 90x30 — red-orange spike pad (avoid)

Color choices come straight from lib/ds/app_colors.dart so visuals stay
on-theme. Antialias via PIL ellipse + GaussianBlur soft-shadow trick.
"""
from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "assets" / "sprites"
OUT.mkdir(parents=True, exist_ok=True)

# Palette: sunset_brasil — derived from lib/ds/app_colors.dart
PRIMARY = (247, 127, 0)        # sunset orange
SECONDARY = (252, 191, 73)     # warm yellow
BACKGROUND_DARK = (57, 27, 14)
BACKGROUND_ALT = (157, 61, 42)
TEXT = (255, 248, 231)
ACCENT = (234, 226, 183)

# Game-specific tones derived from palette
SAFE_GREEN = (118, 184, 82)        # lime against sunset bg
SAFE_GREEN_HIGHLIGHT = (188, 224, 133)
DEAD_RED = (200, 47, 32)
DEAD_RED_HIGHLIGHT = (255, 138, 96)

SHADOW_RGBA = (0, 0, 0, 110)


def _radial_sphere(
    size: int,
    base: tuple[int, int, int],
    highlight: tuple[int, int, int],
) -> Image.Image:
    """Return RGBA disc with vertical gradient for a glossy sphere."""
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    pixels = img.load()
    cx, cy = size / 2, size / 2
    radius = size / 2 - 1
    for y in range(size):
        for x in range(size):
            dx = (x - cx) / radius
            dy = (y - cy) / radius
            d2 = dx * dx + dy * dy
            if d2 > 1.0:
                continue
            # vertical gradient — top = highlight, bottom = base
            t = (y / size) ** 1.4
            r = int(highlight[0] * (1 - t) + base[0] * t)
            g = int(highlight[1] * (1 - t) + base[1] * t)
            b = int(highlight[2] * (1 - t) + base[2] * t)
            edge_fade = max(0.0, 1.0 - (d2 ** 4))
            alpha = int(255 * edge_fade)
            pixels[x, y] = (r, g, b, alpha)
    return img


def _drop_shadow(width: int, height: int, blur: int = 6) -> Image.Image:
    """Return a soft shadow ellipse RGBA the same width as the sprite."""
    pad = blur * 2
    img = Image.new("RGBA", (width + pad * 2, height + pad * 2), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.ellipse(
        [pad, pad, pad + width, pad + height],
        fill=SHADOW_RGBA,
    )
    return img.filter(ImageFilter.GaussianBlur(blur))


def gen_ball() -> None:
    size = 80  # 2x supersample for smoothness then downscale
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    # Drop shadow
    shadow = _drop_shadow(int(size * 0.7), int(size * 0.18), blur=6)
    canvas.alpha_composite(shadow, dest=(int(size * 0.15), int(size * 0.78)))
    # Sphere body — secondary (warm yellow) with primary base
    sphere = _radial_sphere(size, base=PRIMARY, highlight=SECONDARY)
    canvas.alpha_composite(sphere)
    # Glossy spec highlight
    spec = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    sd = ImageDraw.Draw(spec)
    sd.ellipse([size * 0.28, size * 0.18, size * 0.5, size * 0.36],
               fill=(255, 248, 231, 200))
    spec = spec.filter(ImageFilter.GaussianBlur(3))
    canvas.alpha_composite(spec)
    # Two cute eyes (face)
    fd = ImageDraw.Draw(canvas)
    eye_color = BACKGROUND_DARK + (255,)
    fd.ellipse([size * 0.36, size * 0.45, size * 0.46, size * 0.58], fill=eye_color)
    fd.ellipse([size * 0.55, size * 0.45, size * 0.65, size * 0.58], fill=eye_color)
    # Eye shine
    fd.ellipse([size * 0.40, size * 0.47, size * 0.43, size * 0.50],
               fill=(255, 255, 255, 230))
    fd.ellipse([size * 0.59, size * 0.47, size * 0.62, size * 0.50],
               fill=(255, 255, 255, 230))
    out = canvas.resize((40, 40), Image.LANCZOS)
    path = OUT / "ball.png"
    out.save(path)
    print(f"wrote {path} ({path.stat().st_size} bytes)")


def _gen_platform(name: str, base: tuple[int, int, int],
                  highlight: tuple[int, int, int],
                  spikes: bool = False) -> None:
    sup = 4
    w, h = 90 * sup, 30 * sup
    canvas = Image.new("RGBA", (w, h + 12 * sup), (0, 0, 0, 0))
    # Drop shadow under the platform
    shadow = _drop_shadow(w - 8 * sup, 8 * sup, blur=8)
    canvas.alpha_composite(shadow, dest=(4 * sup, h + 2 * sup))
    # Body — rounded rectangle gradient
    body = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    bp = body.load()
    radius = h // 2
    for y in range(h):
        t = (y / h) ** 1.2
        r = int(highlight[0] * (1 - t) + base[0] * t)
        g = int(highlight[1] * (1 - t) + base[1] * t)
        b = int(highlight[2] * (1 - t) + base[2] * t)
        for x in range(w):
            in_round = True
            if x < radius:
                dx = radius - x
                dy = max(0, abs(y - h / 2) - (h / 2 - radius))
                if dx * dx + dy * dy > radius * radius:
                    in_round = False
            elif x > w - radius:
                dx = x - (w - radius)
                dy = max(0, abs(y - h / 2) - (h / 2 - radius))
                if dx * dx + dy * dy > radius * radius:
                    in_round = False
            if in_round:
                bp[x, y] = (r, g, b, 255)
    canvas.alpha_composite(body)
    # Top rim highlight
    rim = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    rd = ImageDraw.Draw(rim)
    rd.rounded_rectangle(
        [4 * sup, 2 * sup, w - 4 * sup, 7 * sup],
        radius=3 * sup,
        fill=(255, 255, 255, 90),
    )
    rim = rim.filter(ImageFilter.GaussianBlur(2 * sup))
    canvas.alpha_composite(rim)
    if spikes:
        sd = ImageDraw.Draw(canvas)
        spike_color = highlight + (255,)
        for i in range(6):
            cx = int((i + 0.5) * w / 6)
            sd.polygon(
                [
                    (cx - 5 * sup, 2 * sup),
                    (cx + 5 * sup, 2 * sup),
                    (cx, -3 * sup),
                ],
                fill=spike_color,
            )
    out = canvas.resize((90, 30 + 4), Image.LANCZOS)
    path = OUT / f"{name}.png"
    out.save(path)
    print(f"wrote {path} ({path.stat().st_size} bytes)")


def gen_platform_safe() -> None:
    _gen_platform("platform_safe", base=(60, 130, 50),
                  highlight=SAFE_GREEN_HIGHLIGHT, spikes=False)


def gen_platform_dead() -> None:
    _gen_platform("platform_dead", base=DEAD_RED,
                  highlight=DEAD_RED_HIGHLIGHT, spikes=True)


def main() -> None:
    gen_ball()
    gen_platform_safe()
    gen_platform_dead()


if __name__ == "__main__":
    main()
