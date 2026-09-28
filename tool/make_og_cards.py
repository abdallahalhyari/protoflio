"""Builds the link previews: 1200x630 cards and /work/<slug>/ share pages.

    python3 tool/make_og_cards.py

Writes web/og/<slug>.jpg from assets/images/projects/<slug>.webp, and the
homepage card web/og-image.png from tool/og_headshot_source.png, and a
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
    'solutions': ('Loyalty Rewards & Ephemeral Social Apps', '4.7+',
                  'average App Store & Play rating'),
    'fais': ('M-Commerce & Media-Streaming Clients', '99.8%',
             'checkout completion, zero duplicate charges'),
}
DISPLAY = 'fonts/Tenada.ttf'
SANS_BOLD = '/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf'
SANS = '/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf'
ACCENT = (129, 140, 248)  # indigo-400: reads on the dark scrim


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
    art = Image.open(f'assets/images/projects/{slug}.webp').convert('RGB')
    scale = max(W / art.width, H / art.height)
    art = art.resize((round(art.width * scale), round(art.height * scale)),
                     Image.LANCZOS)
    left, top = (art.width - W) // 2, (art.height - H) // 2
    img = art.crop((left, top, left + W, top + H)).convert('RGBA')

    # Left-to-right scrim so the text always sits on near-black.
    scrim = Image.new('RGBA', (W, H))
    px = scrim.load()
    for x in range(W):
        a = int(245 * max(0.0, min(1.0, 1.25 - x / (W * 0.72))))
        for y in range(H):
            px[x, y] = (8, 11, 24, a)
    img = Image.alpha_composite(img, scrim)
    d = ImageDraw.Draw(img)

    x, max_w = 64, 640
    d.rectangle((x, 64, x + 44, 68), fill=ACCENT)
    d.text((x, 84), 'CASE STUDY  ·  ABDALLAH ALHYARI',
           font=ImageFont.truetype(SANS_BOLD, 22), fill=(203, 213, 225))

    title_font = ImageFont.truetype(DISPLAY, 50)
    y = 132
    for line in wrap(d, title.upper(), title_font, max_w):
        d.text((x, y), line, font=title_font, fill='white')
        y += 62

    y += 26
    d.text((x, y), metric, font=ImageFont.truetype(DISPLAY, 84), fill=ACCENT)
    y += 100
    for line in wrap(d, caption, ImageFont.truetype(SANS, 28), max_w):
        d.text((x, y), line, font=ImageFont.truetype(SANS, 28),
               fill=(226, 232, 240))
        y += 36

    d.text((x, H - 64), f'alhyari.web.app/work/{slug}',
           font=ImageFont.truetype(SANS_BOLD, 24), fill=(148, 163, 184))
    img.convert('RGB').save(f'web/og/{slug}.jpg', quality=86, optimize=True,
                            progressive=True)




def home_card():
    """web/og-image.png: headshot beside name and role, 1200x630."""
    img = Image.new('RGBA', (W, H), (8, 11, 24, 255))
    photo = Image.open('tool/og_headshot_source.png').convert('RGBA')
    # The source carries a 1px grey frame; trim it.
    photo = photo.crop((3, 3, photo.width - 3, photo.height - 3))
    photo = photo.resize((H, H), Image.LANCZOS)
    img.paste(photo, (W - H, 0))
    # Fade the photo's white backdrop into the dark panel.
    fade = Image.new('RGBA', (W, H))
    px = fade.load()
    start, span = W - H - 10, 300
    for x in range(W):
        a = 255 if x < start else int(255 * max(0.0, 1 - (x - start) / span))
        for y in range(H):
            px[x, y] = (8, 11, 24, a)
    img = Image.alpha_composite(img, fade)
    d = ImageDraw.Draw(img)

    x = 64
    d.rectangle((x, 150, x + 44, 154), fill=ACCENT)
    d.text((x, 176), 'ABDALLAH', font=ImageFont.truetype(DISPLAY, 76),
           fill='white')
    d.text((x, 258), 'ALHYARI', font=ImageFont.truetype(DISPLAY, 76),
           fill='white')
    d.text((x, 362), 'Senior Mobile Engineer', font=ImageFont.truetype(
        SANS_BOLD, 34), fill=ACCENT)
    d.text((x, 406), 'Flutter & Android', font=ImageFont.truetype(
        SANS_BOLD, 34), fill=ACCENT)
    d.text((x, 470), 'Enterprise apps · Offline-first · NFC · Security',
           font=ImageFont.truetype(SANS, 24), fill=(203, 213, 225))
    d.text((x, H - 64), 'alhyari.web.app',
           font=ImageFont.truetype(SANS_BOLD, 24), fill=(148, 163, 184))
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
  <title>{title} — Case Study · Abdallah Alhyari</title>
  <meta name="description" content="{summary}">
  <link rel="canonical" href="{url}">
  <meta property="og:type" content="article">
  <meta property="og:site_name" content="Abdallah Alhyari — Senior Flutter &amp; Android Engineer">
  <meta property="og:title" content="{title} — Case Study">
  <meta property="og:description" content="{summary}">
  <meta property="og:url" content="{url}">
  <meta property="og:image" content="{image}">
  <meta property="og:image:secure_url" content="{image}">
  <meta property="og:image:type" content="image/jpeg">
  <meta property="og:image:width" content="1200">
  <meta property="og:image:height" content="630">
  <meta property="og:image:alt" content="{title}: {metric} {caption}">
  <meta name="theme-color" content="#0E0E10">
  <style>
    html, body {{ margin: 0; height: 100%; background: #0E0E10; color: #E2E8F0;
      font: 16px/1.5 system-ui, -apple-system, "Segoe UI", Roboto, sans-serif; }}
    main {{ min-height: 100%; display: grid; place-items: center; padding: 24px;
      box-sizing: border-box; text-align: center; }}
    a {{ color: #A5B4FC; }}
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
