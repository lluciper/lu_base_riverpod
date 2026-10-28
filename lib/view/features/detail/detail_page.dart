import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/index.dart';
import '../../../resources/generated/l10n.dart';
import 'detail_view_model.dart';

final _provider = NotifierProvider.autoDispose
    .family<DetailViewModel, String?, String?>(DetailViewModel.new);

class DetailPage extends BasePage {
  const DetailPage({this.id, super.key});

  /// From the route query, e.g. `lubaseriverpod://app/home/detail?id=42`.
  final String? id;

  @override
  BasePageState<DetailPage, DetailViewModel> createState() =>
      _DetailPageState();
}

class _DetailPageState extends BasePageState<DetailPage, DetailViewModel> {
  @override
  ViewModelProvider<DetailViewModel, String?> get provider =>
      _provider(widget.id);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) =>
      AppBar(title: Text(S.current.detail_title));

  @override
  Widget buildBody(BuildContext context) {
    final id = provider.listen(ref, (id) => id);
    return Center(
      child: Text(
        id == null ? S.current.detail_no_param : S.current.detail_param(id),
        textAlign: TextAlign.center,
      ),
    );
  }
}
