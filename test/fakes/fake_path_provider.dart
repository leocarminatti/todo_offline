import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakePathProviderPlatform extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  @override
  Future<String> getApplicationDocumentsPath() async {
    return '/tmp'; // Simula um diretório temporário
  }

  @override
  Future<String> getTemporaryPath() async {
    return '/tmp/temp';
  }

  @override
  Future<String> getApplicationCachePath() async {
    return '/tmp/cache';
  }

  @override
  Future<String> getApplicationSupportPath() async {
    return '/tmp/support';
  }

  @override
  Future<String> getDownloadsPath() async {
    return '/tmp/downloads';
  }

  @override
  Future<List<String>> getExternalCachePaths() async {
    return ['/tmp/external_cache'];
  }

  @override
  Future<List<String>?> getExternalStoragePaths(
      {StorageDirectory? type}) async {
    return ['/tmp/external_storage'];
  }

  @override
  Future<String> getExternalStoragePath() async {
    return '/tmp/external_storage';
  }

  @override
  Future<String> getLibraryPath() async {
    return '/tmp/library';
  }
}
