import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class CloudflareAIService {
  final String _accountId = dotenv.env['CLOUDFLARE_ACCOUNT_ID'] ?? '';
  final String _apiToken = dotenv.env['CLOUDFLARE_API_TOKEN'] ?? '';

  Future<String?> generateImage({
    required String prompt,
    File? imageFile,
  }) async {
    final url = Uri.parse(
      'https://api.cloudflare.com/client/v4/accounts/$_accountId/ai/run/@cf/black-forest-labs/flux-2-dev',
    );

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $_apiToken';

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('input_image_0', imageFile.path),
      );
    }

    request.fields['prompt'] = prompt;
    request.fields['steps'] = '15';
    request.fields['width'] = '768';
    request.fields['height'] = '768';

    try {
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 180), // 3 minutes for Flux
        onTimeout: () => throw Exception(
          'Request timeout after 3 minutes. Flux is slow - try again or use shorter prompt.',
        ),
      );

      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('=== Cloudflare Response ===');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.body}');
      debugPrint('===========================');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final imageData = data['result']['image'];
          if (imageData == null || imageData.isEmpty) {
            throw Exception('API returned empty image');
          }
          return 'data:image/png;base64,$imageData';
        } else {
          final errorMsg =
              data['errors']?[0]?['message'] ?? 'Unknown API error';
          throw Exception('API Error: $errorMsg');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API credentials. Check .env file.');
      } else if (response.statusCode == 429) {
        throw Exception('You are generating images too fast! Please wait a moment.');
      } else if (response.statusCode >= 500) {
        throw Exception('The AI server is currently busy or experiencing issues. Please try again in a moment.');
      } else {
        String errorMsg = 'An unexpected error occurred. Please try again.';
        try {
          final data = jsonDecode(response.body);
          if (data['errors'] != null && data['errors'].isNotEmpty) {
            errorMsg = data['errors'][0]['message'] ?? errorMsg;
          }
        } catch (_) {}
        throw Exception(errorMsg);
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('Network error. Check your internet connection.');
      }
      rethrow;
    }
  }
}
