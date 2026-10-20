import 'package:flutter_test/flutter_test.dart';
import 'package:profile/shared/utils/mrz.dart';

void main() {
  group('Mrz.checkDigit', () {
    test('matches the ICAO 9303 specimen values', () {
      // ICAO Doc 9303 Part 5 TD1 specimen (Anna Maria Eriksson, Utopia).
      expect(Mrz.checkDigit('D23145890'), 7);
      expect(Mrz.checkDigit('740812'), 2);
      expect(Mrz.checkDigit('120415'), 9);
    });

    test('treats the filler as zero and letters as 10-35', () {
      expect(Mrz.checkDigit('<<<'), 0);
      expect(Mrz.checkDigit('A'), (10 * 7) % 10);
      expect(Mrz.checkDigit('Z'), (35 * 7) % 10);
    });
  });

  group('Mrz.td1', () {
    test('reproduces the ICAO 9303 TD1 specimen lines', () {
      final lines = Mrz.td1(
        documentCode: 'I',
        issuingState: 'UTO',
        documentNumber: 'D23145890',
        optional1: '',
        birthDate: '740812',
        sex: 'F',
        expiryDate: '120415',
        nationality: 'UTO',
        optional2: '',
        surname: 'ERIKSSON',
        givenNames: 'ANNA MARIA',
      );
      expect(lines, [
        'I<UTOD231458907<<<<<<<<<<<<<<<',
        '7408122F1204159UTO<<<<<<<<<<<6',
        'ERIKSSON<<ANNA<MARIA<<<<<<<<<<',
      ]);
    });

    test('every line is exactly 30 characters', () {
      final lines = Mrz.td1(
        documentCode: 'I',
        issuingState: 'JOR',
        documentNumber: 'MOBILEENG',
        optional1: 'FLUTTER<ANDROID',
        birthDate: '210701',
        sex: '<',
        expiryDate: '270201',
        nationality: 'JOR',
        optional2: 'BRNO<CZE',
        surname: 'ALHYARI',
        givenNames: 'ABDALLAH',
      );
      for (final line in lines) {
        expect(line.length, 30, reason: line);
        expect(RegExp(r'^[A-Z0-9<]+$').hasMatch(line), isTrue, reason: line);
      }
    });
  });
}
