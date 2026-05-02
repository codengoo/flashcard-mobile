import '../../domain/models/user_profile.dart';
import '../services/mock_data_service.dart';

class UserRepository {
  UserProfile getProfile() => MockDataService.currentUser;
}
