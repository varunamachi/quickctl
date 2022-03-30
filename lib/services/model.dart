import 'package:flutter/material.dart';

class GlobalConfig {}

enum DataState {
  initial,
  loading,
  loaded,
  error,
}

typedef ProgressHandler<T> = Widget Function();
typedef StateDataFunc<T> = Widget Function(T? data);
typedef StateErrorFunc<T> = Widget Function(String error);

class MkState<T> {
  DataState state = DataState.initial;
  String? _error;
  T? _data;

  MkState();

  MkState.initial() {
    state = DataState.initial;
    _error = null;
    _data = null;
  }

  MkState.error(String error) {
    state = DataState.error;
    _error = error;
    _data = null;
  }

  MkState.loaded(T data) {
    state = DataState.loaded;
    _error = null;
    _data = data;
  }

  MkState.loading() {
    state = DataState.loading;
    _error = null;
    _data = null;
  }

  String? get error => _error;
  T? get data => _data;

  Widget when({
    required StateDataFunc<T> onData,
    required StateErrorFunc onError,
    ProgressHandler? onProgress,
  }) {
    switch (state) {
      case DataState.initial:
        return const Text('-- --- -- -- - --');
      case DataState.loading:
        return onProgress != null
            ? onProgress()
            : const Center(child: CircularProgressIndicator());
      case DataState.loaded:
        return onData(_data);
      case DataState.error:
        return onError(_error ?? 'Failed');
    }
  }
}
