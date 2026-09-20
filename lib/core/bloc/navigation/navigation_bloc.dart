import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/service/url_sync_service.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc({int initialPage = 0, int pageCount = 7})
      : super(NavigationState(pageIndex: initialPage, pageCount: pageCount)) {
    on<NavigationPageSelected>(_onPageSelected);
    on<NavigationNextPageRequested>(_onNextPageRequested);
    on<NavigationPrevPageRequested>(_onPrevPageRequested);
    on<NavigationUrlHashReceived>(_onUrlHashReceived);
    on<NavigationScrollToTopToggled>(_onScrollToTopToggled);
    on<NavigationMobileSectionScrolled>(_onMobileSectionScrolled);
  }

  void _onPageSelected(
    NavigationPageSelected event,
    Emitter<NavigationState> emit,
  ) {
    final clamped = event.pageIndex.clamp(0, state.pageCount - 1);
    if (clamped == state.pageIndex) return;
    emit(state.copyWith(pageIndex: clamped));
  }

  void _onNextPageRequested(
    NavigationNextPageRequested event,
    Emitter<NavigationState> emit,
  ) {
    if (state.pageIndex < state.pageCount - 1) {
      emit(state.copyWith(pageIndex: state.pageIndex + 1));
    }
  }

  void _onPrevPageRequested(
    NavigationPrevPageRequested event,
    Emitter<NavigationState> emit,
  ) {
    if (state.pageIndex > 0) {
      emit(state.copyWith(pageIndex: state.pageIndex - 1));
    }
  }

  void _onUrlHashReceived(
    NavigationUrlHashReceived event,
    Emitter<NavigationState> emit,
  ) {
    final clean = event.hash.replaceAll('#', '').split('/').first;
    if (clean.isEmpty) return;
    final targetIndex = UrlSyncService.instance.hashToIndex(clean);
    final clamped = targetIndex.clamp(0, state.pageCount - 1);
    if (clamped != state.pageIndex) {
      emit(state.copyWith(pageIndex: clamped));
    }
  }

  void _onScrollToTopToggled(
    NavigationScrollToTopToggled event,
    Emitter<NavigationState> emit,
  ) {
    if (state.showScrollToTop != event.showScrollToTop) {
      emit(state.copyWith(showScrollToTop: event.showScrollToTop));
    }
  }

  void _onMobileSectionScrolled(
    NavigationMobileSectionScrolled event,
    Emitter<NavigationState> emit,
  ) {
    final clamped = event.sectionIndex.clamp(0, state.pageCount - 1);
    emit(state.copyWith(pageIndex: clamped));
  }
}
