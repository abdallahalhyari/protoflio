"""Builds fonts/ReadexPro.ttf from the upstream Readex Pro variable font.

    pip install fonttools
    python3 tool/subset_readex.py path/to/ReadexPro[HEXP,wght].ttf

The engine fetches this file before the first frame, so its size sits on
the critical path (Lighthouse charges every byte that lands before the boot
screen paints). Two cuts, neither changes how text renders:

- The HEXP ("hyper expansion") axis is pinned at its default. The site never
  sets it, and its deltas were a third of the file. The wght axis stays.
- Glyphs are limited to the scripts the site is written in (Latin incl.
  Czech, Arabic) plus punctuation, currency, letterlike and math symbols.
  Every layout feature is kept, so Arabic shaping is untouched.

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


def used_codepoints():
    used = set()
    for path in (glob.glob('lib/**/*.dart', recursive=True) +
                 glob.glob('lib/l10n/*.arb') + glob.glob('assets/data/*.json')):
        with open(path, encoding='utf-8') as f:
            used |= {ord(c) for c in f.read()}
    return used


def main(source):
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

    lost = (original - set(font.getBestCmap())) & used_codepoints()
    if lost:
        sys.exit('Would drop used characters: ' +
                 ' '.join(f'U+{cp:04X} {chr(cp)}' for cp in sorted(lost)))
    font.save(OUT)
    print(f'Wrote {OUT}')


if __name__ == '__main__':
    main(sys.argv[1])
