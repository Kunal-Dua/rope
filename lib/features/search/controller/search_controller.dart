import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/features/auth/repository/auth_repository.dart';
import 'package:rope/models/user_model.dart';

final searchControllerProvider = StateNotifierProvider((ref) {
  return SearchController(authRepository: ref.watch(authRepositoryProvider));
});

final searchUserProvider = FutureProvider.family((ref, String name) async {
  final searchController = ref.watch(searchControllerProvider.notifier);
  return searchController.searchUser(name);
});

class SearchController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  SearchController({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(false);

  Future<List<UserModel>> searchUser(String name) {
    return _authRepository.getUserByName(name);
  }
}
