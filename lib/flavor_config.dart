enum Flavor { free, paid }

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final bool isPremiumEnabled;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String name,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor: flavor,
      name: name,
      isPremiumEnabled: flavor == Flavor.paid,
    );
    return _instance!;
  }

  FlavorConfig._internal({
    required this.flavor,
    required this.name,
    required this.isPremiumEnabled,
  });

  static FlavorConfig get instance {
    return _instance!;
  }

  static bool get isPaid => _instance!.flavor == Flavor.paid;
  static bool get isFree => _instance!.flavor == Flavor.free;
}