// lib/services/cloudinary_service.dart
import 'package:cloudinary/cloudinary.dart';

class CloudinaryService {
  final Cloudinary cloudinary;

  CloudinaryService()
      : cloudinary = Cloudinary.signedConfig(
          cloudName: 'dc6nq0pb1',
          apiKey: '392385925718134',
          apiSecret: 'pMtNbKN4WwLbtsJnc0Yzvqgf75k',
        );

  Future<String> uploadFile({
    required String filePath,
    required String folder,
    CloudinaryResourceType resourceType = CloudinaryResourceType.image,
  }) async {
    try {
      final response = await cloudinary.upload(
        file: filePath,
        resourceType: resourceType,
        folder: folder,
      );
      return response.secureUrl!;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }
}
