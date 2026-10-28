import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lubaseriverpod/core/index.dart';
import 'package:lubaseriverpod/data/index.dart';

import '../helpers/fakes.dart';

class _CounterViewModel extends BaseViewModel<({int a, int b})> {
  @override
  ({int a, int b}) build() => (a: 0, b: 0);

  void incrementA() => state = (a: state.a + 1, b: state.b);

  void incrementB() => state = (a: state.a, b: state.b + 1);

  Repository readRepository() => repository;
}

final _provider =
    NotifierProvider.autoDispose<_CounterViewModel, ({int a, int b})>(
      _CounterViewModel.new,
    );

void main() {
  test('build() provides the initial state', () {
    final container = ProviderContainer.test();
    expect(container.read(_provider), (a: 0, b: 0));
  });

  test('repository getter reads repositoryProvider', () {
    final repository = FakeRepository();
    final container = ProviderContainer.test(
      overrides: [repositoryProvider.overrideWithValue(repository)],
    );
    expect(
      container.read(_provider.notifier).readRepository(),
      same(repository),
    );
  });

  test('LoadingWrapperViewModel toggles loading state', () {
    final provider =
        NotifierProvider.autoDispose<LoadingWrapperViewModel, bool>(
          LoadingWrapperViewModel.new,
        );
    final container = ProviderContainer.test();
    container.listen(provider, (_, _) {});

    expect(container.read(provider), isFalse);
    container.read(provider.notifier).showLoading();
    expect(container.read(provider), isTrue);
    container.read(provider.notifier).dismissLoading();
    expect(container.read(provider), isFalse);
  });

  testWidgets('viewModel(ref) returns the notifier, listen(ref) rebuilds only '
      'when the selected value changes', (tester) async {
    var builds = 0;
    late _CounterViewModel viewModel;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              builds++;
              viewModel = _provider.viewModel(ref);
              return Text('a=${_provider.listen(ref, (s) => s.a)}');
            },
          ),
        ),
      ),
    );
    expect(find.text('a=0'), findsOneWidget);
    expect(builds, 1);

    viewModel.incrementB();
    await tester.pump();
    expect(builds, 1, reason: 'b is not selected, must not rebuild');

    viewModel.incrementA();
    await tester.pump();
    expect(builds, 2);
    expect(find.text('a=1'), findsOneWidget);
  });
}
