/// ICAO 9303 machine-readable zone helpers (TD1, the ID-1 card format).
///
/// Only what the About & contact sheet needs: check digits and three
/// 30-character lines. Field values must already be MRZ-safe (A–Z, 0–9, `<`).
abstract final class Mrz {
  /// ICAO 9303 check digit: characters weighted 7, 3, 1 in turn, where
  /// digits count as themselves, A–Z as 10–35 and the filler `<` as 0.
  static int checkDigit(String field) {
    const weights = [7, 3, 1];
    var sum = 0;
    for (var i = 0; i < field.length; i++) {
      sum += _value(field.codeUnitAt(i)) * weights[i % 3];
    }
    return sum % 10;
  }

  static int _value(int c) {
    if (c >= 0x30 && c <= 0x39) return c - 0x30; // 0-9
    if (c >= 0x41 && c <= 0x5A) return c - 0x41 + 10; // A-Z
    return 0; // '<'
  }

  static String _pad(String s, int width) =>
      s.length >= width ? s.substring(0, width) : s.padRight(width, '<');

  /// The three TD1 lines, each exactly 30 characters, with the document
  /// number, date and composite check digits computed.
  static List<String> td1({
    required String documentCode,
    required String issuingState,
    required String documentNumber,
    required String optional1,
    required String birthDate,
    required String sex,
    required String expiryDate,
    required String nationality,
    required String optional2,
    required String surname,
    required String givenNames,
  }) {
    final number = _pad(documentNumber, 9);
    final opt1 = _pad(optional1, 15);
    final opt2 = _pad(optional2, 11);

    final line1 = '${_pad(documentCode, 2)}${_pad(issuingState, 3)}'
        '$number${checkDigit(number)}$opt1';

    final birth = '$birthDate${checkDigit(birthDate)}';
    final expiry = '$expiryDate${checkDigit(expiryDate)}';
    final composite = checkDigit(
      '${line1.substring(5)}$birth$expiry$opt2',
    );
    final line2 =
        '$birth${_pad(sex, 1)}$expiry${_pad(nationality, 3)}$opt2$composite';

    final line3 = _pad('$surname<<${givenNames.replaceAll(' ', '<')}', 30);

    return [line1, line2, line3];
  }
}
