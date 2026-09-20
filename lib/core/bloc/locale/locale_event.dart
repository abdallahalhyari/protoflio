import 'package:equatable/equatable.dart';

sealed class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object?> get props => [];
}

class LocaleStarted extends LocaleEvent {
  const LocaleStarted();
}

class LocaleChanged extends LocaleEvent {
  final String languageCode;

  const LocaleChanged(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class NextLocaleRequested extends LocaleEvent {
  const NextLocaleRequested();
}
