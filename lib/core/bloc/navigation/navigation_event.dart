import 'package:equatable/equatable.dart';

sealed class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

class NavigationPageSelected extends NavigationEvent {
  final int pageIndex;

  const NavigationPageSelected(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}

class NavigationNextPageRequested extends NavigationEvent {
  const NavigationNextPageRequested();
}

class NavigationPrevPageRequested extends NavigationEvent {
  const NavigationPrevPageRequested();
}

class NavigationUrlHashReceived extends NavigationEvent {
  final String hash;

  const NavigationUrlHashReceived(this.hash);

  @override
  List<Object?> get props => [hash];
}

class NavigationScrollToTopToggled extends NavigationEvent {
  final bool showScrollToTop;

  const NavigationScrollToTopToggled(this.showScrollToTop);

  @override
  List<Object?> get props => [showScrollToTop];
}

class NavigationMobileSectionScrolled extends NavigationEvent {
  final int sectionIndex;

  const NavigationMobileSectionScrolled(this.sectionIndex);

  @override
  List<Object?> get props => [sectionIndex];
}
