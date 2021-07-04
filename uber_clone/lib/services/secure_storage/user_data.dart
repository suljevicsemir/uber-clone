import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uber_clone/models/signed_in_type.dart';
import 'package:uber_clone/models/user_data.dart';
import 'package:uber_clone/user_data_fields.dart' as user_data_fields;
class SecureStorage {

  FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();

  Future<bool> saveUser(UserData userData) async {
    try{
      await _flutterSecureStorage.write(key: user_data_fields.providerUserId, value: userData.providerUserId);
      await _flutterSecureStorage.write(key: user_data_fields.firstName, value: userData.firstName);
      await _flutterSecureStorage.write(key: user_data_fields.lastName, value: userData.lastName);
      await _flutterSecureStorage.write(key: user_data_fields.email, value: userData.email);
      await _flutterSecureStorage.write(key: user_data_fields.signedInType, value: userData.signedInType.parseSignedInType());
      await _flutterSecureStorage.write(key: user_data_fields.profilePictureUrl, value: userData.profilePictureUrl);
      await _flutterSecureStorage.write(key: user_data_fields.firebaseUserId, value: userData.firebaseUserId);
      return true;
    }
    catch (err) {
      return false;
    }
  }

  Future<UserData?> loadUser() async {
    Map<String, String> data = await _flutterSecureStorage.readAll();
    if(data.isEmpty)
      return null;
    print(data);
    return UserData.fromLocalStorage(data);
  }

  Future<void> updateProfileUrl(String url) async {
    await _flutterSecureStorage.write(key: user_data_fields.firebaseUserId, value: url);
  }


}