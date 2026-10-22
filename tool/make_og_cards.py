"""Builds the link previews: 1200x630 cards and /work/<slug>/ share pages.

    python3 tool/make_og_cards.py

Writes web/og/<slug>.jpg from assets/images/projects/<slug>.webp, and the
homepage card web/og-image.png from assets/my_image.webp, and a
share page per study at web/work/<slug>/index.html. Link-preview crawlers
never see the `#work/<slug>` fragment the app routes on, so shared case
study links used to preview as the homepage. Each share page carries the
study's own tags and forwards people to `/#work/<slug>`. Re-run after
changing a title, summary, headline metric, artwork or the headshot.
"""
import html
import os

from PIL import Image, ImageDraw, ImageFont

W, H = 1200, 630
STUDIES = {
    'nathealth': ('NatHealth Mobile Suite', '< 1s',
                  'contactless smart-card verification'),
    'eskadenia': ('E-Learning & Healthcare Enterprise Suite', '60 FPS',
                  'on dense hospital data tables'),
    'solutions': ('Loyalty Rewards & Ephemeral Social Media Apps', '4.7+',
                  'average App Store & Play rating'),
    'fais': ('M-Commerce & Media-Streaming Clients', '99.8%',
             'checkout completion, zero duplicate charges'),
}
DISPLAY = 'fonts/Tenada.ttf'  # the name only, as on the site's cover
SANS = 'fonts/ReadexPro.ttf'     # everything else (variable weight)

# The site's dark theme (lib/core/theme/tokens/colors.dart).
INK_TOP = (13, 19, 27)       # stageDarkStart
INK = (11, 16, 24)           # darkCanvas
INK_BOTTOM = (9, 14, 20)     # stageDarkEnd
GOLD = (191, 153, 66)        # dark-theme primary, as on the cover's surname
GOLD_SOFT = (227, 203, 142)  # goldSoft, figures on ink
TEXT = (255, 255, 255)
MUTED = (186, 188, 191)      # white at 72% on ink (mutedText)
RULE = (42, 52, 66)          # glassBorderStrong on ink


def sans(size, weight='Regular'):
    font = ImageFont.truetype(SANS, size)
    font.set_variation_by_name(weight)
    return font


def ink_background():
    img = Image.new('RGB', (W, H))
    d = ImageDraw.Draw(img)
    for y in range(H):
        t = y / (H - 1)
        a, b = (INK_TOP, INK) if t < 0.5 else (INK, INK_BOTTOM)
        u = t * 2 if t < 0.5 else (t - 0.5) * 2
        d.line([(0, y), (W, y)],
               fill=tuple(round(a[i] + (b[i] - a[i]) * u) for i in range(3)))
    return img.convert('RGBA')


def wrap(draw, text, font, width):
    lines, line = [], ''
    for word in text.split():
        trial = f'{line} {word}'.strip()
        if draw.textlength(trial, font=font) <= width:
            line = trial
        else:
            lines.append(line)
            line = word
    return lines + [line]


def card(slug, title, metric, caption):
    """web/og/<slug>.jpg: the study's artwork, its title and one figure."""
    art = Image.open(f'assets/images/projects/{slug}.webp').convert('RGB')
    scale = max(W / art.width, H / art.height)
    art = art.resize((round(art.width * scale), round(art.height * scale)),
                     Image.LANCZOS)
    left, top = (art.width - W) // 2, (art.height - H) // 2
    img = art.crop((left, top, left + W, top + H)).convert('RGBA')

    # Fade the artwork into ink from the left so the text sits on ink.
    scrim = Image.new('RGBA', (W, H))
    px = scrim.load()
    for x in range(W):
        a = int(250 * max(0.0, min(1.0, 1.3 - x / (W * 0.7))))
        for y in range(H):
            px[x, y] = (*INK, a)
    img = Image.alpha_composite(img, scrim)
    d = ImageDraw.Draw(img)

    x, max_w = 72, 620
    d.text((x, 72), 'Case study', font=sans(26, 'Medium'), fill=MUTED)

    title_font = sans(52, 'Bold')
    y = 116
    for line in wrap(d, title, title_font, max_w):
        d.text((x, y), line, font=title_font, fill=TEXT)
        y += 64

    y += 28
    d.text((x, y), metric, font=sans(88, 'Bold'), fill=GOLD_SOFT)
    y += 112
    caption_font = sans(28)
    for line in wrap(d, caption, caption_font, max_w):
        d.text((x, y), line, font=caption_font, fill=TEXT)
        y += 38

    d.text((x, H - 72), f'alhyari.web.app/work/{slug}',
           font=sans(24, 'Medium'), fill=MUTED)
    img.convert('RGB').save(f'web/og/{slug}.jpg', quality=86, optimize=True,
                            progressive=True)


def home_card():
    """web/og-image.png: the site's cover as a card. Name, role and
    availability on ink; the colour portrait on its white print."""
    img = ink_background()
    d = ImageDraw.Draw(img)

    # Portrait: the photo at its own proportions on a white print with a
    # hairline edge, as beside the cover's statement.
    # The cut-out has a transparent backdrop; the print is white.
    cut = Image.open('assets/my_image.webp').convert('RGBA')
    photo = Image.new('RGBA', cut.size, (255, 255, 255, 255))
    photo = Image.alpha_composite(photo, cut).convert('RGB')
    ph = 486
    pw = round(photo.width * ph / photo.height)
    photo = photo.resize((pw, ph), Image.LANCZOS)
    px0, py0 = W - 72 - pw, (H - ph) // 2
    mask = Image.new('L', (pw, ph), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, pw - 1, ph - 1), 10,
                                           fill=255)
    img.paste(photo, (px0, py0), mask)
    d.rounded_rectangle((px0 - 1, py0 - 1, px0 + pw, py0 + ph), 11,
                        outline=RULE, width=2)

    x = 72
    name = ImageFont.truetype(DISPLAY, 92)
    d.text((x, 118), 'ABDALLAH', font=name, fill=TEXT)
    d.text((x, 208), 'ALHYARI', font=name, fill=GOLD)
    d.text((x, 338), 'Senior mobile engineer, Flutter & Android',
           font=sans(36, 'SemiBold'), fill=TEXT)
    y = 394
    for line in wrap(d, 'Available now for remote and contract work. '
                        'On-site in Brno from February 2027.', sans(26), 560):
        d.text((x, y), line, font=sans(26), fill=MUTED)
        y += 36
    d.text((x, H - 72), 'alhyari.web.app', font=sans(24, 'Medium'),
           fill=MUTED)
    img.convert('RGB').save('web/og-image.png', optimize=True)


SUMMARIES = {
    'nathealth': 'NFC smart-card healthcare suite for Jordan\'s largest '
                 'health-insurance TPA: card verification in under a second, '
                 'claims that survive connectivity drops, zero security '
                 'breaches.',
    'eskadenia': 'Incremental MVVM refactor of hospital and university apps: '
                 '60 FPS on dense data tables, 35% fewer crashes, zero '
                 'downtime across four enterprise platforms.',
    'solutions': 'Two consumer apps shipped on schedule: a hardware-'
                 'accelerated camera pipeline, a shared design system, a 4.7+ '
                 'store rating and 40% faster feature turnaround.',
    'fais': 'Idempotent m-commerce checkout and resilient media streaming: '
            '99.8% checkout completion with zero duplicate charges and 45% '
            'fewer support escalations.',
}

PAGE = """<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Generated by tool/make_og_cards.py. Edit there, not here. -->
  <title>{title} — case study by Abdallah Alhyari</title>
  <meta name="description" content="{summary}">
  <link rel="canonical" href="{url}">
  <meta property="og:type" content="article">
  <meta property="og:site_name" content="Abdallah Alhyari — Senior mobile engineer, Flutter &amp; Android">
  <meta property="og:title" content="{title} — case study">
  <meta property="og:description" content="{summary}">
  <meta property="og:url" content="{url}">
  <meta property="og:image" content="{image}">
  <meta property="og:image:secure_url" content="{image}">
  <meta property="og:image:type" content="image/jpeg">
  <meta property="og:image:width" content="1200">
  <meta property="og:image:height" content="630">
  <meta property="og:image:alt" content="{title}: {metric} {caption}">
  <meta name="theme-color" content="#0B1018">
  <style>
    html, body {{ margin: 0; height: 100%; background: #0B1018; color: #E2E8F0;
      font: 16px/1.5 system-ui, -apple-system, "Segoe UI", Roboto, sans-serif; }}
    main {{ min-height: 100%; display: grid; place-items: center; padding: 24px;
      box-sizing: border-box; text-align: center; }}
    a {{ color: #E3CB8E; }}
  </style>
  <script>
    // People go straight to the case study; crawlers read the tags above.
    location.replace('/' + location.search + '#work/{slug}');
  </script>
</head>
<body>
  <main>
    <p>Opening the <a href="/#work/{slug}">{title} case study</a>…</p>
  </main>
</body>
</html>
"""


def share_page(slug, title, metric, caption):
    esc = lambda s: html.escape(s, quote=True)
    out = PAGE.format(
        slug=slug,
        title=esc(title),
        summary=esc(SUMMARIES[slug]),
        metric=esc(metric),
        caption=esc(caption),
        url=f'https://alhyari.web.app/work/{slug}/',
        image=f'https://alhyari.web.app/og/{slug}.jpg',
    )
    os.makedirs(f'web/work/{slug}', exist_ok=True)
    with open(f'web/work/{slug}/index.html', 'w', encoding='utf-8') as f:
        f.write(out)


if __name__ == '__main__':
    for slug, (title, metric, caption) in STUDIES.items():
        card(slug, title, metric, caption)
        share_page(slug, title, metric, caption)
        print('wrote', f'web/og/{slug}.jpg', f'web/work/{slug}/index.html')
    home_card()
    print('wrote web/og-image.png')
