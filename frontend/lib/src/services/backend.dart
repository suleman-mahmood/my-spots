import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myspots/src/services/auth.dart';
import 'package:myspots/src/services/models.dart' as model;

class BackendService {
  // For localhost in an emulator
  // final String apiUrl = 'http://10.0.2.2:5000/api/v1';

  // For Ngrok, development
  final String apiUrl = 'https://2ec9-111-68-103-169.ngrok-free.app/api/v1';

  // For deployment in GCP
  // final String apiUrl = 'https://my-spots-1.uk.r.appspot.com/api/v1';

  Future<void> checkApi() async {
    final url = Uri.parse('$apiUrl');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("API is working");
    } else {
      print("API is not working");
    }
  }

  Future<void> createUser(model.User user) async {
    final token = await AuthService().user?.getIdToken() ?? '';

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

  Future<void> createReel(model.Reel reel, String tags) async {
    final token = await AuthService().user?.getIdToken() ?? '';

    final url = Uri.parse('$apiUrl/create-reel');
    final res = await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        "video_url": reel.videoUrl,
        "location": reel.location,
        "spot_name": reel.spotName,
        "caption": reel.caption,
        "description": reel.description,
        "thumbnail_url": reel.thumbnailUrl,
        // "tags": tags, TODO: change implementation for tags here
        "tags": reel.tags
            .map((e) => <String, dynamic>{"id": e.id, "tag_name": e.tagName})
            .toList(),
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(res.body);
  }

  Future<void> followUser(String userToFollowId) async {
    final token = await AuthService().user?.getIdToken() ?? '';

    final url = Uri.parse('$apiUrl/follow-user');
    await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        "user_to_follow_id": userToFollowId,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<void> likeReel(String reelId) async {
    final token = await AuthService().user?.getIdToken() ?? '';

    final url = Uri.parse('$apiUrl/like-reel');
    await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        "reel_id": reelId,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<void> favouriteReel(String reelId) async {
    final token = await AuthService().user?.getIdToken() ?? '';

    final url = Uri.parse('$apiUrl/favourite-reel');
    await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        "reel_id": reelId,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<void> commentReel(String reelId, String commentText) async {
    final token = await AuthService().user?.getIdToken() ?? '';

    final url = Uri.parse('$apiUrl/comment-reel');
    await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        "reel_id": reelId,
        "comment_text": commentText,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<void> reportReel(String reelId, String reportText) async {
    final token = await AuthService().user?.getIdToken() ?? '';

    final url = Uri.parse('$apiUrl/report-reel');
    await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        "reel_id": reelId,
        "report_text": reportText,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  // The getters start here

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

  Future<model.User> getAnyUser(String userId) async {
    final url = Uri.parse('$apiUrl/get-any-user?user_id=$userId');
    final response = await http.get(url);

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

  Future<List<model.Tag>> getAllTags() async {
    final url = Uri.parse('$apiUrl/get-all-tags');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // API call successful
      print(response.body);

      List<model.Tag> tags = [];

      var jsonResponse = json.decode(response.body);
      for (var i = 0; i < jsonResponse["tags"].length; i++) {
        var tag = jsonResponse["tags"][i];
        tags.add(model.Tag.fromJson(tag));
      }

      return tags;
    } else {
      // API call failed
      print('API call failed with status code: ${response.statusCode}');

      return [];
    }
  }

  Future<List<model.Reel>> getUserReels(String userId) async {
    final url = Uri.parse('$apiUrl/get-user-reels?user_id=$userId');
    final response = await http.get(
      url,
    );

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

  Future<List<model.Reel>> getUserFavouriteReels() async {
    final token = await AuthService().user?.getIdToken() ?? '';

    final url = Uri.parse('$apiUrl/get-user-favourite-reels');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

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

  Future<List<model.Reel>> getExploreReels() async {
    final token = await AuthService().user?.getIdToken() ?? '';

    final url = Uri.parse('$apiUrl/get-nearest-reels');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

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
    final token = await AuthService().user?.getIdToken() ?? '';

    final url = Uri.parse('${apiUrl}/get-following-reels');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

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

  Future<List<model.Reel>> getSearchReels(String searchText) async {
    final token = await AuthService().user?.getIdToken() ?? '';

    final url = Uri.parse('${apiUrl}/get-search-reels?search_text=$searchText');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

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

  Future<List<model.Comment>> getReelComments(String reelId) async {
    final url = Uri.parse('$apiUrl/get-reel-comments?reel_id=$reelId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // API call successful
      var jsonResponse = json.decode(response.body);
      var comments = jsonResponse['comments']
          .map<model.Comment>((e) => model.Comment.fromJson(e))
          .toList();

      return comments;
    } else {
      // API call failed
      print('API call failed with status code: ${response.statusCode}');

      return [];
    }
  }
}
