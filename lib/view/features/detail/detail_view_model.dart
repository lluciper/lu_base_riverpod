import '../../../core/index.dart';

/// One ViewModel per [id] (provider family): the route/deep-link param arrives
/// through the constructor. Loading data by [id] later belongs here.
class DetailViewModel extends BaseViewModel<String?> {
  DetailViewModel(this._id);

  final String? _id;

  @override
  String? build() => _id;
}
