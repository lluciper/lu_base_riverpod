import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/index.dart';

/// Every ViewModel needs to inherit from this class.
/// Mỗi ViewModel cần kế thừa từ lớp này.
///
/// Override [build] to return the initial state.
/// Ghi đè [build] để trả về state khởi tạo.
abstract class BaseViewModel<T> extends Notifier<T> {
  @protected
  Repository get repository => ref.read(repositoryProvider);
}

typedef ViewModelProvider<NotifierT extends Notifier<StateT>, StateT> =
    NotifierProvider<NotifierT, StateT>;

extension ViewModelProviderExtension<NotifierT extends Notifier<StateT>, StateT>
    on NotifierProvider<NotifierT, StateT> {
  NotifierT viewModel(WidgetRef ref) => ref.read(notifier);

  Selected listen<Selected>(
    WidgetRef ref,
    Selected Function(StateT value) selector,
  ) => ref.watch(select(selector));
}
