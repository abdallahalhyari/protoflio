"""Builds fonts/ReadexPro.ttf from the upstream Readex Pro variable font.

    pip install fonttools brotli
    python3 tool/subset_readex.py path/to/ReadexPro[HEXP,wght].ttf \
        path/to/NotoSansSymbols-Regular.ttf

The engine fetches this file before the first frame, so its size sits on
the critical path (Lighthouse charges every byte that lands before the boot
screen paints). Two cuts, neither changes how text renders:

- The HEXP ("hyper expansion") axis is pinned at its default. The site never
  sets it, and its deltas were a third of the file. The wght axis stays.
- Glyphs are limited to the scripts the site is written in (Latin incl.
  Czech, Arabic) plus punctuation, currency, letterlike and math symbols.
  Every layout feature is kept, so Arabic shaping is untouched.

Readex Pro has no arrows, yet the intro's "Amman → Brno" line uses one, so
every visit fetched Noto Sans Symbols from Google as a fallback and then laid
out all the text again once it arrived. The arrows are copied in from that
same font (also OFL, Copyright 2022 The Noto Project Authors), so they render
exactly as before, without the download. Any Noto Sans Symbols file with
U+2190-2194 works, e.g. @fontsource/noto-sans-symbols' "symbols" subset.

The script refuses to write a font that drops a character used anywhere in
lib/, the ARB files or assets/data/.
"""

import glob
import io
import sys

from fontTools import subset
from fontTools.ttLib import TTFont
from fontTools.varLib import instancer

OUT = 'fonts/ReadexPro.ttf'

RANGES = [
    (0x0020, 0x007E),  # Basic Latin
    (0x00A0, 0x024F),  # Latin-1, Latin Extended-A/B (Czech)
    (0x02B0, 0x036F),  # spacing modifiers, combining marks
    (0x0600, 0x06FF),  # Arabic
    (0x0750, 0x077F),  # Arabic Supplement
    (0x08A0, 0x08FF),  # Arabic Extended-A
    (0xFB50, 0xFDFF),  # Arabic Presentation Forms-A
    (0xFE70, 0xFEFF),  # Arabic Presentation Forms-B
    (0x2000, 0x206F),  # General Punctuation
    (0x20A0, 0x20BF),  # Currency
    (0x2100, 0x22FF),  # Letterlike, arrows, math operators
]

# ← ↑ → ↓ ↔, taken from Noto Sans Symbols.
ARROWS = range(0x2190, 0x2195)


def add_arrows(font, source):
    """Copies the ARROWS glyphs from [source] into [font], unvaried by wght
    (as the fallback font drew them). Both fonts use 1000 units per em."""
    donor = TTFont(source)
    assert donor['head'].unitsPerEm == font['head'].unitsPerEm
    donor_cmap = donor.getBestCmap()
    order = font.getGlyphOrder()
    hvar = font['HVAR'].table
    # One shared item with no deltas: the arrows' advances don't vary.
    var_data = hvar.VarStore.VarData[0]
    var_data.Item.append([0] * var_data.VarRegionCount)
    var_data.ItemCount = len(var_data.Item)
    no_delta = len(var_data.Item) - 1
    added = []
    for cp in ARROWS:
        donor_name = donor_cmap[cp]
        glyph = donor['glyf'][donor_name]
        assert not glyph.isComposite(), donor_name
        name = f'uni{cp:04X}'
        added.append(name)
        font['glyf'].glyphs[name] = glyph
        font['hmtx'][name] = donor['hmtx'][donor_name]
        font['gvar'].variations[name] = []
        hvar.AdvWidthMap.mapping[name] = no_delta
        for table in font['cmap'].tables:
            if table.isUnicode():
                table.cmap[cp] = name
    font.setGlyphOrder(order + added)
    font['maxp'].numGlyphs = len(order) + len(added)
    font['glyf'].glyphOrder = order + added


def used_codepoints():
    used = set()
    for path in (glob.glob('lib/**/*.dart', recursive=True) +
                 glob.glob('lib/l10n/*.arb') + glob.glob('assets/data/*.json')):
        with open(path, encoding='utf-8') as f:
            used |= {ord(c) for c in f.read()}
    return used


def main(source, arrows_source):
    font = TTFont(source)
    original = set(font.getBestCmap())
    font = instancer.instantiateVariableFont(font, {'HEXP': 0})
    # Round-trip before subsetting: the instancer leaves gvar half-built.
    buffer = io.BytesIO()
    font.save(buffer)
    buffer.seek(0)
    font = TTFont(buffer)

    options = subset.Options()
    options.layout_features = ['*']
    options.name_IDs = ['*']
    options.name_languages = ['*']
    options.notdef_outline = True
    options.hinting = False
    subsetter = subset.Subsetter(options)
    subsetter.populate(unicodes=[cp for lo, hi in RANGES
                                 for cp in range(lo, hi + 1)])
    subsetter.subset(font)
    add_arrows(font, arrows_source)

    lost = (original - set(font.getBestCmap())) & used_codepoints()
    if lost:
        sys.exit('Would drop used characters: ' +
                 ' '.join(f'U+{cp:04X} {chr(cp)}' for cp in sorted(lost)))
    font.save(OUT)
    print(f'Wrote {OUT}')


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
