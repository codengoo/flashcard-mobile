import 'package:flutter/foundation.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../domain/models/user_profile.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({required UserRepository userRepository})
      : _userRepository = userRepository {
    _init();
  }

  final UserRepository _userRepository;
  late UserProfile _profile;

  UserProfile get profile => _profile;

  void _init() {
    _profile = _userRepository.getProfile();
  }
}
