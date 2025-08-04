import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lubaseriverpod/resources/resources.dart';

import '../../data/repositories/repository.dart';
import '../../utils/index.dart';
import '../index.dart';

/// Every page needs to inherit from this class.
/// A page should not be created with `StateFulWidget`
/// Mỗi trang cần kế thừa từ lớp này.
/// Trang không nên được tạo với `StatefulWidget`.
abstract class BasePage extends ConsumerStatefulWidget {
  const BasePage({super.key});
}

abstract class BasePageState<Page extends BasePage, VM extends BaseViewModel>
    extends ConsumerState<Page>
    with BasePageMixin, WidgetsBindingObserver {
  late LoadingWrapperViewModel _loadingViewModel;

  final _loadingProvider =
      StateNotifierProvider.autoDispose<LoadingWrapperViewModel, bool>(
        (ref) => LoadingWrapperViewModel(),
      );

  bool isShowingError = false;

  /// This is the only presenter of the page.
  /// Use it instead of creating a new presenter.
  /// Đây là presenter duy nhất của trang.
  /// Sử dụng nó thay vì tạo presenter mới.
  ///
  VM get viewModel;

  @override
  @Deprecated('Override `onInitState()` instead of `initState()`')
  // Ghi đè `onInitState()` thay vì `initState()`.
  void initState() {
    super.initState();
    //Inject instance presenter for this page
    // Tiêm instance presenter cho trang này
    RefreshService.addPageInitialized(pageName);
    _loadingViewModel = _loadingProvider.viewModel(ref);
    onInitState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => onStateCreated(context),
    );
  }

  @override
  @mustCallSuper
  @Deprecated(
    // Ghi đè `buildPage()` thay vì `build()`. Nếu cần ghi đè `build`, có thể bỏ qua dòng này.
    'Override `buildPage()` instead of `build()`. '
    'If it is required to override build, can ignore this line',
  )
  Widget build(BuildContext context) => buildPage(context);

  @override
  @Deprecated('Override `onDispose()` instead of `dispose()`')
  // Ghi đè `onDispose()` thay vì `dispose()`.
  void dispose() {
    RefreshService.removePageInitialized(pageName);
    onDispose();
    super.dispose();
  }

  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  Widget buildBody(BuildContext context);

  Widget buildPage(BuildContext context) => PopScope(
    onPopInvokedWithResult: onPopWithResult(),
    child: LoadingWrapper(
      provider: _loadingProvider,
      child: hasUseSafeArea
          ? SafeArea(child: _bodyInsideSafeArea())
          : _bodyInsideSafeArea(),
    ),
  );

  Widget _bodyInsideSafeArea() => VisibilityWrapper(
    onAppeared: () {
      onAppearedPage();
      if (RefreshService.hadRefresh(pageName)) {
        RefreshService.removePage(pageName);
        onRefreshPage();
      }
    },
    onDisappeared: onDisappearedPage,
    child: GestureDetector(
      onTap: tapOutsideHideKeyBoard
          ? () {
              FocusScope.of(context).requestFocus(FocusNode());
            }
          : null,
      child: Scaffold(
        backgroundColor: context.colors.background,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: buildAppBar(context),
        body: buildBody(context),
      ),
    ),
  );

  void showLoadingDialog() {
    _loadingViewModel.showLoading();
  }

  void dismissLoadingDialog() {
    // ignore: deprecated_member_use_from_same_package
    if (viewModel.futuresIsEmpty) {
      _loadingViewModel.dismissLoading();
    }
  }

  void forceDismissLoading() {
    _loadingViewModel.dismissLoading();
  }

  /// If override this function, you should not call super,
  /// dialog error will show the first error of the page
  /// Nếu ghi đè hàm này, bạn không nên gọi super, hộp thoại lỗi sẽ hiển thị lỗi đầu tiên của trang.
  Future<void> handleError(Object? error) async {
    await DialogPlatform(
      content: ErrorHelper.getError(context, error),
    ).show(context);
  }

  /// If override this function, you should not call super,
  /// dialog error show duplicate if have many error
  /// Nếu ghi đè hàm này, bạn không nên gọi super, hộp thoại lỗi sẽ hiển thị trùng lặp nếu có nhiều lỗi.
  void handlerFutureError(Object? error) {
    if (!isShowingError) {
      isShowingError = true;
      handleError(error);
      isShowingError = false;
    }
  }
}

mixin BasePageMixin {
  /// This function is called when the start page state is initialized.
  /// Can't get context here
  /// Hàm này được gọi khi trạng thái trang bắt đầu được khởi tạo. Không thể lấy context tại đây.
  @mustCallSuper
  void onInitState() {
    LoggerHelper.info('[Page][$pageName] is initializing state');
  }

  /// This function is called when the page state has been created.
  /// The context can be obtained here
  /// Hàm này được gọi khi trạng thái trang đã được tạo. Context có thể lấy ở đây.
  @mustCallSuper
  void onStateCreated(BuildContext context) {
    LoggerHelper.info('[Page][$pageName] is created state');
  }

  /// This function is called when this page is re-rendered on the screen
  /// (Instance reappears after being completely covered by another page
  /// or newly created).
  ///
  /// In case of page transition effect,
  /// the modal is called when the actual page transition is finished
  /// Hàm này được gọi khi trang được hiển thị lại trên màn hình
  /// (xuất hiện lại sau khi bị trang khác che phủ hoặc mới được tạo).
  /// Trong trường hợp hiệu ứng chuyển trang, hàm này được gọi khi quá trình
  /// chuyển trang thực sự hoàn thành.
  @mustCallSuper
  void onAppearedPage() {
    LoggerHelper.info('[Page][$pageName] is appeared');
  }

  /// This function is called when this page disappears from the screen
  /// (In case it is completely covered by another page or page is disposed).
  ///
  /// In case of page transition effect,
  /// the modal is called when the actual page transition is finished
  /// Hàm này được gọi khi trang biến mất khỏi màn hình (bị trang khác che phủ
  ///  hoàn toàn hoặc bị dispose).
  /// Trong trường hợp hiệu ứng chuyển trang, hàm này được gọi khi quá trình
  /// chuyển trang thực sự hoàn thành.
  @mustCallSuper
  void onDisappearedPage() {
    LoggerHelper.info('[Page][$pageName] is disappeared');
  }

  /// This function is called when the page is actually disposed
  /// Hàm này được gọi khi trang thực sự bị dispose.
  @mustCallSuper
  void onDispose() {
    LoggerHelper.info('[Page][$pageName] is disposing ');
  }

  @mustCallSuper
  void onRefreshPage() {
    LoggerHelper.info('[Page][$pageName] reloading');
  }

  /// When this function is overridden.
  /// It will be called when a pop command is called on the navigator.
  /// Khi hàm này được ghi đè, nó sẽ được gọi khi lệnh pop được gọi trên navigator.
  PopInvokedWithResultCallback? onPopWithResult() => null;

  bool get resizeToAvoidBottomInset => false;

  /// If this property is `true`
  /// then it will allow tap outside the screen to hide the keyboard
  /// Nếu thuộc tính này là `true`
  /// thì sẽ cho phép chạm ngoài màn hình để ẩn bàn phím
  bool get tapOutsideHideKeyBoard => true;

  /// This is page background color
  /// Đây là màu nền của trang
  Color? get backgroundColor => null;

  /// If this property is `true`
  /// then it will wrap this page by the `SafeArea` Widget
  /// Nếu thuộc tính này là `true`
  /// thì nó sẽ bao bọc trang này bởi `SafeArea` Widget
  bool get hasUseSafeArea => false;

  String get pageName => (this as State).widget.runtimeType.toString();
}

extension ViewModelProviderExtension<
  NotifierT extends StateNotifier<StateT>,
  StateT
>
    on AutoDisposeStateNotifierProvider<NotifierT, StateT> {
  NotifierT viewModel(WidgetRef ref) => ref.read(notifier);

  Selected listen<Selected>(
    WidgetRef ref,
    Selected Function(StateT value) selector,
  ) => ref.watch(select(selector));
}

typedef ViewModelProvider<NotifierT extends StateNotifier<StateT>, StateT> =
    AutoDisposeStateNotifierProvider<NotifierT, StateT>;

class BaseViewModel<T> extends StateNotifier<T> {
  BaseViewModel(super.state);

  T get getState => state;

  final Set<Future> _futures = {};

  Repository get repository => injector.read(repositoryProvider);

  @Deprecated(
    'Do not call this method directly for processing. '
    'This is the internal method',
  )
  // Không gọi phương thức này trực tiếp để xử lý. Đây là phương thức nội bộ.
  void addFuture(Future future) {
    _futures.add(future);
  }

  @Deprecated(
    'Do not call this method directly for processing. '
    'This is the internal method',
  )
  // Không gọi phương thức này trực tiếp để xử lý. Đây là phương thức nội bộ.
  void removeFuture(Future future) {
    _futures.remove(future);
  }

  @Deprecated(
    'Do not call this method directly for processing. '
    'This is the internal method',
  )
  // Không gọi phương thức này trực tiếp để xử lý. Đây là phương thức nội bộ.
  void clearAllFuture() {
    _futures.clear();
  }

  @Deprecated(
    'Do not call this method directly for processing. '
    'This is the internal method',
  )
  // Không truy cập trực tiếp thuộc tính này để kiểm tra. Đây là thuộc tính nội bộ.
  bool get futuresIsEmpty => _futures.isEmpty;
}
