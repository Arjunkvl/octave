import 'package:palette_generator/palette_generator.dart';

Future<PaletteGenerator> setDynamicColor(image) async {
  final paletteGenerator = await PaletteGenerator.fromImageProvider(image);
  return paletteGenerator;
}
