import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../resources/resources.dart';
import '../utils/index.dart';
import 'index.dart';

/// Every page needs to inherit from this class.
/// A page should not be created with `StateFulWidget`
/// Mỗi trang cần kế thừa từ lớp này.
/// Trang không nên được tạo với `StatefulWidget`.
abstract class BasePage extends ConsumerStatefulWidget {
  const BasePage({super.key});
}

abstract class BasePageState<P extends BasePage, VM extends BaseViewModel>
    extends ConsumerState<P>
    with BasePageMixin {
  final _loadingProvider =
      NotifierProvider.autoDispose<LoadingWrapperViewModel, bool>(
        LoadingWrapperViewModel.new,
      );

  bool isShowingError = false;

  /// Futures subscribed with [FutureEx.subscribeLoadingFullScreen].
  final Set<Future> _loadingFutures = {};

  /// The page's ViewModel provider, declared private top-level in the page file.
  /// Provider ViewModel của trang, khai báo private top-level trong file page.
  ViewModelProvider<VM, Object?> get provider;

  /// This is the only ViewModel of the page. Use it instead of creating a new one.
  /// Đây là ViewModel duy nhất của trang. Dùng nó thay vì tạo ViewModel mới.
  VM get viewModel => provider.viewModel(ref);

  @override
  @Deprecated('Override `onInitState()` instead of `initState()`')
  // Ghi đè `onInitState()` thay vì `initState()`.
  void initState() {
    super.initState();
    //Inject instance presenter for this page
    // Tiêm instance presenter cho trang này
    RefreshService.addPageInitialized(pageName);
    // Keeps the autoDispose ViewModel alive for the page's lifetime, even when
    // nothing in the page watches it.
    ref.listenManual(provider, (_, _) {});
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
              FocusManager.instance.primaryFocus?.unfocus();
            }
          : null,
      child: Scaffold(
        backgroundColor: backgroundColor ?? context.colors.background,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: buildAppBar(context),
        body: buildBody(context),
      ),
    ),
  );

  // Futures may complete after the page is disposed; ref is unusable then.
  void showLoadingDialog() {
    if (!mounted) return;
    _loadingProvider.viewModel(ref).showLoading();
  }

  /// Hides the loading overlay unless a subscribed future is still running.
  void dismissLoadingDialog() {
    if (!mounted || _loadingFutures.isNotEmpty) return;
    _loadingProvider.viewModel(ref).dismissLoading();
  }

  void forceDismissLoading() {
    if (!mounted) return;
    _loadingProvider.viewModel(ref).dismissLoading();
  }

  /// If override this function, you should not call super,
  /// dialog error will show the first error of the page
  /// Nếu ghi đè hàm này, bạn không nên gọi super, hộp thoại lỗi sẽ hiển thị lỗi đầu tiên của trang.
  Future<void> handleError(Object? error) async {
    await DialogPlatform(content: ErrorHelper.getError(error)).show(context);
  }

  /// If override this function, you should not call super,
  /// dialog error show duplicate if have many error
  /// Nếu ghi đè hàm này, bạn không nên gọi super, hộp thoại lỗi sẽ hiển thị trùng lặp nếu có nhiều lỗi.
  void handlerFutureError(Object? error) {
    if (mounted && !isShowingError) {
      isShowingError = true;
      handleError(error).whenComplete(() => isShowingError = false);
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

  bool get resizeToAvoidBottomInset => true;

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

extension FutureEx<T> on Future<T> {
  /// Call this function to show a loading full screen on page
  Future<T> subscribeLoadingFullScreen(BasePageState pageState) {
    pageState._loadingFutures.add(this);
    pageState.showLoadingDialog();
    return whenComplete(() {
      pageState._loadingFutures.remove(this);
      pageState.dismissLoadingDialog();
    });
  }

  /// Call this method to subscribe to receive data when the data returns
  /// successfully. Note future must be a future that returns data.
  /// [success] is a UI action (navigate, show message): skipped once the page
  /// is disposed, so it may use the page's `context`.
  Future<T> subscribeOnSuccess(
    BasePageState pageState, {
    Function(T data)? success,
  }) => then((value) {
    if (pageState.mounted) success?.call(value);
    return this;
  });

  /// Call this method to subscribe to receive error on catch error.
  /// Completes with `null` on error, so it must be the last call in the chain.
  Future<T?> subscribeHandleError(
    BasePageState pageState, {
    Function(Object? error)? onError,
  }) => then<T?>((value) => value).catchError((
    Object error,
    StackTrace stackTrace,
  ) {
    // API errors are expected; anything else is a bug worth reporting.
    if (error is! DioException) reportError(error, stackTrace);
    if (!pageState.mounted) return null;
    // Other subscribed futures may still run: the overlay stays until they end.
    pageState.dismissLoadingDialog();
    if (onError == null) {
      pageState.handlerFutureError(error);
    } else {
      onError.call(error);
    }
    return null;
  });
}
