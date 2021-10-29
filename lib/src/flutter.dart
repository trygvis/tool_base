import 'package:tool_base/src/base/file_system.dart';
import 'package:tool_base/src/base/platform.dart';

/// Gets the path to the root of the Flutter repository.
///
/// This will first look for a `FLUTTER_ROOT` environment variable. If the
/// environment variable is set, it will be returned. Otherwise, this will
/// deduce the path from `platform.script`.
String getFlutterRoot() {
  final flutterRoot = platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null)
    return flutterRoot;

  Error invalidScript() => StateError('Invalid script: ${platform.script}');

  Uri scriptUri;
  switch (platform.script.scheme) {
    case 'file':
      scriptUri = platform.script;
      break;
    case 'data':
      final flutterTools = RegExp(r'(file://[^"]*[/\\]flutter_tools[/\\][^"]+\.dart)', multiLine: true);
      final match = flutterTools.firstMatch(Uri.decodeFull(platform.script.path));
      if (match == null)
        throw invalidScript();
      scriptUri = Uri.parse(match.group(1)!);
      break;
    default:
      throw invalidScript();
  }

  final List<String> parts = fs.path.split(fs.path.fromUri(scriptUri));
  final int toolsIndex = parts.indexOf('flutter_tools');
  if (toolsIndex == -1)
    throw invalidScript();
  final String toolsPath = fs.path.joinAll(parts.sublist(0, toolsIndex + 1));
  return fs.path.normalize(fs.path.join(toolsPath, '..', '..'));
}
