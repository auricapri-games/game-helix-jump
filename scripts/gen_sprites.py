"""Generate sprites for Helix Jump using sunset_brasil palette.

Sprites:
  ball.png              36x36   yellow ball with gradient + shadow
  disc_segment_safe.png 90x16   safe segment (orange/yellow gradient)
  disc_segment_deadly.png 90x16 deadly segment (red with spike hint)
  tower_pole.png        20x800  dark vertical pole

Palette (sunset_brasil):
  primary       #F77F00 orange
  secondary     #FCBF49 yellow
  background    #391B0E dark brown
  backgroundAlt #9D3D2A burnt red
  text          #FFF8E7 cream
  accent        #EAE2B7 pale cream
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter

OUT = Path(__file__).resolve().parent.parent / "assets" / "sprites"
OUT.mkdir(parents=True, exist_ok=True)

PRIMARY = (247, 127, 0, 255)
SECONDARY = (252, 191, 73, 255)
BACKGROUND = (57, 27, 14, 255)
BACKGROUND_ALT = (157, 61, 42, 255)
TEXT = (255, 248, 231, 255)
ACCENT = (234, 226, 183, 255)
DEADLY = (220, 50, 30, 255)
DEADLY_DARK = (130, 20, 10, 255)
POLE_DARK = (28, 14, 7, 255)


def lerp(a, b, t):
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(len(a)))


def draw_ball():
    """Yellow/orange ball with gradient + soft drop shadow."""
    size = 36
    pad = 4
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    # Shadow (slightly offset, blurred)
    shadow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.ellipse([pad + 2, pad + 4, size - pad + 2, size - pad + 4],
               fill=(0, 0, 0, 110))
    shadow = shadow.filter(ImageFilter.GaussianBlur(radius=2))
    img = Image.alpha_composite(img, shadow)

    # Body — radial-ish gradient simulated by concentric ellipses
    d = ImageDraw.Draw(img)
    cx, cy = size / 2, size / 2 - 1
    radius = (size - pad * 2) / 2
    steps = 18
    for i in range(steps, 0, -1):
        t = i / steps
        # outer ring darker (more orange), inner brighter (yellow/cream)
        c = lerp(SECONDARY, TEXT, 1 - t)
        if i > steps - 3:
            c = lerp(PRIMARY, SECONDARY, (steps - i) / 3)
        r = radius * (i / steps)
        d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=c)

    # Highlight (small white dot top-left for shine)
    hi = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    hd = ImageDraw.Draw(hi)
    hd.ellipse([cx - radius * 0.55, cy - radius * 0.7,
                cx - radius * 0.15, cy - radius * 0.3],
               fill=(255, 255, 255, 160))
    hi = hi.filter(ImageFilter.GaussianBlur(radius=1.2))
    img = Image.alpha_composite(img, hi)

    img.save(OUT / "ball.png")
    print(f"Wrote {OUT / 'ball.png'}")


def draw_segment_safe():
    """Safe segment 90x16 — orange→yellow gradient with bevel."""
    w, h = 90, 16
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # Rounded rectangle base
    d.rounded_rectangle([0, 0, w - 1, h - 1], radius=6, fill=PRIMARY)
    # Top bevel (lighter)
    d.rounded_rectangle([1, 1, w - 2, h // 2], radius=5, fill=SECONDARY)
    # Inner highlight line
    d.line([5, 2, w - 6, 2], fill=(255, 240, 200, 200), width=1)
    # Bottom shadow
    d.line([4, h - 2, w - 5, h - 2], fill=(120, 60, 0, 140), width=1)
    img.save(OUT / "disc_segment_safe.png")
    print(f"Wrote {OUT / 'disc_segment_safe.png'}")


def draw_segment_deadly():
    """Deadly segment 90x16 — red with subtle spike hint along top."""
    w, h = 90, 16
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rounded_rectangle([0, 0, w - 1, h - 1], radius=6, fill=DEADLY_DARK)
    # Body gradient: bottom darker, top brighter red
    d.rounded_rectangle([1, h // 2, w - 2, h - 2], radius=5,
                        fill=(180, 30, 20, 255))
    d.rounded_rectangle([1, 1, w - 2, h // 2], radius=5, fill=DEADLY)
    # Spike hints — small triangles along top edge
    spike_count = 6
    spike_w = (w - 12) / spike_count
    for i in range(spike_count):
        x0 = 6 + i * spike_w
        x1 = x0 + spike_w
        cx = (x0 + x1) / 2
        d.polygon([(x0 + 1, 3), (cx, 0), (x1 - 1, 3)],
                  fill=(255, 230, 200, 200))
    # Bottom shadow line
    d.line([4, h - 2, w - 5, h - 2], fill=(60, 0, 0, 200), width=1)
    img.save(OUT / "disc_segment_deadly.png")
    print(f"Wrote {OUT / 'disc_segment_deadly.png'}")


def draw_pole():
    """Dark vertical pole 20x800 with subtle gradient shading."""
    w, h = 20, 800
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # Body
    d.rounded_rectangle([0, 0, w - 1, h - 1], radius=6, fill=POLE_DARK)
    # Left highlight column
    d.line([3, 4, 3, h - 5], fill=(80, 40, 20, 200), width=1)
    d.line([4, 4, 4, h - 5], fill=(60, 30, 15, 200), width=1)
    # Right shadow column
    d.line([w - 4, 4, w - 4, h - 5], fill=(10, 5, 2, 220), width=1)
    img.save(OUT / "tower_pole.png")
    print(f"Wrote {OUT / 'tower_pole.png'}")


def draw_mascot():
    """Decorative mascot ball for the home screen — bigger, glowy."""
    size = 160
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    # Soft outer glow
    glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gd.ellipse([14, 14, size - 14, size - 14], fill=(247, 127, 0, 110))
    glow = glow.filter(ImageFilter.GaussianBlur(radius=14))
    img = Image.alpha_composite(img, glow)
    # Drop shadow
    shadow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.ellipse([26, 32, size - 26, size - 18], fill=(0, 0, 0, 150))
    shadow = shadow.filter(ImageFilter.GaussianBlur(radius=6))
    img = Image.alpha_composite(img, shadow)
    # Body radial gradient
    d = ImageDraw.Draw(img)
    cx, cy = size / 2, size / 2 - 4
    radius = (size - 36) / 2
    steps = 28
    for i in range(steps, 0, -1):
        t = i / steps
        c = lerp(SECONDARY, TEXT, 1 - t)
        if i > steps - 4:
            c = lerp(PRIMARY, SECONDARY, (steps - i) / 4)
        r = radius * (i / steps)
        d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=c)
    # Highlight
    hi = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    hd = ImageDraw.Draw(hi)
    hd.ellipse([cx - radius * 0.55, cy - radius * 0.75,
                cx - radius * 0.10, cy - radius * 0.30],
               fill=(255, 255, 255, 200))
    hi = hi.filter(ImageFilter.GaussianBlur(radius=3))
    img = Image.alpha_composite(img, hi)
    # Cute eyes
    d2 = ImageDraw.Draw(img)
    eye_y = cy + 4
    eye_dx = radius * 0.32
    eye_r = radius * 0.10
    for sx in (-1, 1):
        ex = cx + sx * eye_dx
        d2.ellipse([ex - eye_r, eye_y - eye_r, ex + eye_r, eye_y + eye_r],
                   fill=BACKGROUND)
        # white shine
        d2.ellipse([ex - eye_r * 0.5, eye_y - eye_r * 0.7,
                    ex - eye_r * 0.1, eye_y - eye_r * 0.3],
                   fill=(255, 255, 255, 230))
    # Smile arc
    sm_r = radius * 0.45
    d2.arc([cx - sm_r, cy + radius * 0.05, cx + sm_r, cy + radius * 0.55],
           start=10, end=170, fill=BACKGROUND, width=3)

    img.save(OUT / "mascot.png")
    print(f"Wrote {OUT / 'mascot.png'}")


if __name__ == "__main__":
    draw_ball()
    draw_segment_safe()
    draw_segment_deadly()
    draw_pole()
    draw_mascot()
    print("All sprites generated.")
