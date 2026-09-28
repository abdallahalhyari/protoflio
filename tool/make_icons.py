"""Builds the favicon, Apple touch icon and PWA icons from the site's mark:
the gradient "A" tile used on the loading screen and in the mobile app bar.

    python3 tool/make_icons.py

Replaces the default Flutter logo (PWA / home-screen icons) and a
non-square stock photo (favicon).
"""
from PIL import Image, ImageDraw, ImageFont

FONT = 'fonts/Tenada.ttf'
# Loading-screen emblem: linear-gradient(135deg, #6366F1, #8B5CF6, #EC4899).
STOPS = [(0.0, (0x63, 0x66, 0xF1)), (0.5, (0x8B, 0x5C, 0xF6)),
         (1.0, (0xEC, 0x48, 0x99))]
SS = 4  # supersampling for smooth edges


def _lerp(stops, t):
    for (t0, c0), (t1, c1) in zip(stops, stops[1:]):
        if t <= t1:
            f = (t - t0) / (t1 - t0)
            return tuple(round(a + (b - a) * f) for a, b in zip(c0, c1))
    return stops[-1][1]


def _gradient(size):
    """135deg: top-left to bottom-right."""
    img = Image.new('RGB', (size, size))
    px = img.load()
    for y in range(size):
        for x in range(size):
            px[x, y] = _lerp(STOPS, (x + y) / (2 * (size - 1)))
    return img


def tile(size, *, rounded, glyph_frac):
    """rounded: corner radius as a fraction of size (0 = full-bleed square).
    glyph_frac: cap height of the "A" as a fraction of size."""
    big = size * SS
    img = _gradient(big).convert('RGBA')
    d = ImageDraw.Draw(img)
    font = ImageFont.truetype(FONT, 100)
    cap = d.textbbox((0, 0), 'A', font=font)
    font = ImageFont.truetype(FONT, round(100 * big * glyph_frac /
                                          (cap[3] - cap[1])))
    # Optical centre: centre the glyph's ink box, not its line box.
    box = d.textbbox((0, 0), 'A', font=font)
    x = (big - (box[2] - box[0])) / 2 - box[0]
    y = (big - (box[3] - box[1])) / 2 - box[1]
    d.text((x, y), 'A', font=font, fill='white')
    if rounded:
        mask = Image.new('L', (big, big), 0)
        ImageDraw.Draw(mask).rounded_rectangle(
            (0, 0, big - 1, big - 1), radius=round(big * rounded), fill=255)
        img.putalpha(mask)
    return img.resize((size, size), Image.LANCZOS)


if __name__ == '__main__':
    outputs = {
        # Browser tab: rounded tile, big glyph so it reads at 16px.
        'web/favicon.png': tile(48, rounded=0.22, glyph_frac=0.56),
        # iOS rounds the corners itself and ignores transparency.
        'web/icons/apple-touch-icon.png': tile(180, rounded=0,
                                               glyph_frac=0.46),
        'web/icons/Icon-192.png': tile(192, rounded=0.22, glyph_frac=0.48),
        'web/icons/Icon-512.png': tile(512, rounded=0.22, glyph_frac=0.48),
        # Maskable: full bleed, glyph inside the 80% safe circle.
        'web/icons/Icon-maskable-192.png': tile(192, rounded=0,
                                                glyph_frac=0.36),
        'web/icons/Icon-maskable-512.png': tile(512, rounded=0,
                                                glyph_frac=0.36),
    }
    for path, img in outputs.items():
        img.save(path, optimize=True)
        print('wrote', path, img.size)
