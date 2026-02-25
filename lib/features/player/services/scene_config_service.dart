import 'dart:convert';

import 'package:http/http.dart' as http;

class SceneConfigService {
  // Use the 'raw' GitHub link for the JSON file
  final String configUrl =
      "https://raw.githubusercontent.com/gokulekd/lumina-hearth-assets/main/scenes_config.json";

  Future<List<dynamic>> fetchRemoteScenes() async {
    try {
      final response = await http.get(Uri.parse(configUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['scenes'];
      } else {
        throw Exception('Failed to load scenes');
      }
    } catch (e) {
      // Fallback to a local JSON if the user is offline
      print("Error fetching remote config: $e");
      return [];
    }
  }
}
