import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myspots/services/models.dart' as model;

class BackendService {
  final String apiUrl = 'http://10.0.2.2:5000/api/v1';

  Future<void> checkApi() async {
    final url = Uri.parse('$apiUrl');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("API is working");
    } else {
      print("API is not working");
    }
  }

  Future<void> createUser(model.User user, String token) async {
    final url = Uri.parse('$apiUrl/create-user');
    await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        "full_name": user.fullName,
        "user_name": user.userName,
        "email": user.email,
        "phone_number": user.phoneNumber,
        "profile_text": user.profileText,
        "location": user.location,
        "avatar_url": user.avatarUrl,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<model.User> getUser(String token) async {
    final url = Uri.parse('$apiUrl/get-user');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // API call successful
      var jsonResponse = json.decode(response.body);
      var user = model.User.fromJson(jsonResponse['user']);

      return user;
    } else {
      // API call failed
      print('API call failed with status code: ${response.statusCode}');

      return model.User();
    }
  }

  Future<List<model.Reel>> getExploreReels() async {
    final url = Uri.parse('$apiUrl/get-nearest-reels');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // API call successful
      print(response.body);

      List<model.Reel> reels = [];

      var jsonResponse = json.decode(response.body);
      for (var i = 0; i < jsonResponse["reels"].length; i++) {
        var jsonReel = jsonResponse["reels"][i];
        reels.add(model.Reel.fromJson(jsonReel));
      }

      return reels;
    } else {
      // API call failed
      print('API call failed with status code: ${response.statusCode}');

      return [];
    }
  }

  Future<List<model.Reel>> getFollowingReels() async {
    final url = Uri.parse('${apiUrl}/get-following-reel');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // API call successful
      print(response.body);

      List<model.Reel> reels = [];

      var jsonResponse = json.decode(response.body);
      for (var i = 0; i < jsonResponse["reels"].length; i++) {
        var jsonReel = jsonResponse["reels"][i];
        reels.add(model.Reel.fromJson(jsonReel));
      }

      return reels;
    } else {
      // API call failed
      print('API call failed with status code: ${response.statusCode}');

      return [];
    }
  }
}
