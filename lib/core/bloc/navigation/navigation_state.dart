import 'package:equatable/equatable.dart';

class NavigationState extends Equatable {
  final int pageIndex;
  final bool showScrollToTop;
  final int pageCount;
  final bool isTransitioning;

  const NavigationState({
    this.pageIndex = 0,
    this.showScrollToTop = false,
    this.pageCount = 7,
    this.isTransitioning = false,
  });

  bool get canGoBack => pageIndex > 0;
  bool get canGoForward => pageIndex < pageCount - 1;

  NavigationState copyWith({
    int? pageIndex,
    bool? showScrollToTop,
    int? pageCount,
    bool? isTransitioning,
  }) {
    return NavigationState(
      pageIndex: pageIndex ?? this.pageIndex,
      showScrollToTop: showScrollToTop ?? this.showScrollToTop,
      pageCount: pageCount ?? this.pageCount,
      isTransitioning: isTransitioning ?? this.isTransitioning,
    );
  }

  @override
  List<Object?> get props => [
        pageIndex,
        showScrollToTop,
        pageCount,
        isTransitioning,
      ];
}
