// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RadioStore on RadioStoreBase, Store {
  Computed<String?>? _$currentUrlComputed;

  @override
  String? get currentUrl => (_$currentUrlComputed ??= Computed<String?>(
    () => super.currentUrl,
    name: 'RadioStoreBase.currentUrl',
  )).value;
  Computed<String?>? _$selectedUrlComputed;

  @override
  String? get selectedUrl => (_$selectedUrlComputed ??= Computed<String?>(
    () => super.selectedUrl,
    name: 'RadioStoreBase.selectedUrl',
  )).value;

  late final _$isPlayingAtom = Atom(
    name: 'RadioStoreBase.isPlaying',
    context: context,
  );

  @override
  bool get isPlaying {
    _$isPlayingAtom.reportRead();
    return super.isPlaying;
  }

  @override
  set isPlaying(bool value) {
    _$isPlayingAtom.reportWrite(value, super.isPlaying, () {
      super.isPlaying = value;
    });
  }

  late final _$currentStationAtom = Atom(
    name: 'RadioStoreBase.currentStation',
    context: context,
  );

  @override
  RadioStation? get currentStation {
    _$currentStationAtom.reportRead();
    return super.currentStation;
  }

  @override
  set currentStation(RadioStation? value) {
    _$currentStationAtom.reportWrite(value, super.currentStation, () {
      super.currentStation = value;
    });
  }

  late final _$selectedStationAtom = Atom(
    name: 'RadioStoreBase.selectedStation',
    context: context,
  );

  @override
  RadioStation? get selectedStation {
    _$selectedStationAtom.reportRead();
    return super.selectedStation;
  }

  @override
  set selectedStation(RadioStation? value) {
    _$selectedStationAtom.reportWrite(value, super.selectedStation, () {
      super.selectedStation = value;
    });
  }

  late final _$processingStateAtom = Atom(
    name: 'RadioStoreBase.processingState',
    context: context,
  );

  @override
  ProcessingState get processingState {
    _$processingStateAtom.reportRead();
    return super.processingState;
  }

  @override
  set processingState(ProcessingState value) {
    _$processingStateAtom.reportWrite(value, super.processingState, () {
      super.processingState = value;
    });
  }

  late final _$lastPlayerStateAtom = Atom(
    name: 'RadioStoreBase.lastPlayerState',
    context: context,
  );

  @override
  PlayerState? get lastPlayerState {
    _$lastPlayerStateAtom.reportRead();
    return super.lastPlayerState;
  }

  @override
  set lastPlayerState(PlayerState? value) {
    _$lastPlayerStateAtom.reportWrite(value, super.lastPlayerState, () {
      super.lastPlayerState = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: 'RadioStoreBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$initAsyncAction = AsyncAction(
    'RadioStoreBase.init',
    context: context,
  );

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$playStationAsyncAction = AsyncAction(
    'RadioStoreBase.playStation',
    context: context,
  );

  @override
  Future<void> playStation(RadioStation station) {
    return _$playStationAsyncAction.run(() => super.playStation(station));
  }

  late final _$playAsyncAction = AsyncAction(
    'RadioStoreBase.play',
    context: context,
  );

  @override
  Future<void> play() {
    return _$playAsyncAction.run(() => super.play());
  }

  late final _$stopAsyncAction = AsyncAction(
    'RadioStoreBase.stop',
    context: context,
  );

  @override
  Future<void> stop() {
    return _$stopAsyncAction.run(() => super.stop());
  }

  late final _$testStationAsyncAction = AsyncAction(
    'RadioStoreBase.testStation',
    context: context,
  );

  @override
  Future<void> testStation(RadioStation station) {
    return _$testStationAsyncAction.run(() => super.testStation(station));
  }

  late final _$nextStationAsyncAction = AsyncAction(
    'RadioStoreBase.nextStation',
    context: context,
  );

  @override
  Future<void> nextStation() {
    return _$nextStationAsyncAction.run(() => super.nextStation());
  }

  late final _$previousStationAsyncAction = AsyncAction(
    'RadioStoreBase.previousStation',
    context: context,
  );

  @override
  Future<void> previousStation() {
    return _$previousStationAsyncAction.run(() => super.previousStation());
  }

  late final _$RadioStoreBaseActionController = ActionController(
    name: 'RadioStoreBase',
    context: context,
  );

  @override
  Future<void> pause() {
    final _$actionInfo = _$RadioStoreBaseActionController.startAction(
      name: 'RadioStoreBase.pause',
    );
    try {
      return super.pause();
    } finally {
      _$RadioStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isPlaying: ${isPlaying},
currentStation: ${currentStation},
selectedStation: ${selectedStation},
processingState: ${processingState},
lastPlayerState: ${lastPlayerState},
errorMessage: ${errorMessage},
currentUrl: ${currentUrl},
selectedUrl: ${selectedUrl}
    ''';
  }
}
