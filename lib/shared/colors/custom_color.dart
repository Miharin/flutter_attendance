import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

const defaultcolor = Color(0xFFB2A6FF);

CustomColors lightCustomColors = const CustomColors(
  sourceDefaultcolor: Color(0xFFB2A6FF),
  defaultcolor: Color(0xFF5E52A7),
  onDefaultcolor: Color(0xFFFFFFFF),
  defaultcolorContainer: Color(0xFFE5DEFF),
  onDefaultcolorContainer: Color(0xFF190261),
);

CustomColors darkCustomColors = const CustomColors(
  sourceDefaultcolor: Color(0xFFB2A6FF),
  defaultcolor: Color(0xFFC8BFFF),
  onDefaultcolor: Color(0xFF2F2175),
  defaultcolorContainer: Color(0xFF463A8D),
  onDefaultcolorContainer: Color(0xFFE5DEFF),
);

/// Defines a set of custom colors, each comprised of 4 complementary tones.
///
/// See also:
///   * <https://m3.material.io/styles/color/the-color-system/custom-colors>
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.sourceDefaultcolor,
    required this.defaultcolor,
    required this.onDefaultcolor,
    required this.defaultcolorContainer,
    required this.onDefaultcolorContainer,
  });

  final Color? sourceDefaultcolor;
  final Color? defaultcolor;
  final Color? onDefaultcolor;
  final Color? defaultcolorContainer;
  final Color? onDefaultcolorContainer;

  @override
  CustomColors copyWith({
    Color? sourceDefaultcolor,
    Color? defaultcolor,
    Color? onDefaultcolor,
    Color? defaultcolorContainer,
    Color? onDefaultcolorContainer,
  }) {
    return CustomColors(
      sourceDefaultcolor: sourceDefaultcolor ?? this.sourceDefaultcolor,
      defaultcolor: defaultcolor ?? this.defaultcolor,
      onDefaultcolor: onDefaultcolor ?? this.onDefaultcolor,
      defaultcolorContainer:
          defaultcolorContainer ?? this.defaultcolorContainer,
      onDefaultcolorContainer:
          onDefaultcolorContainer ?? this.onDefaultcolorContainer,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      sourceDefaultcolor:
          Color.lerp(sourceDefaultcolor, other.sourceDefaultcolor, t),
      defaultcolor: Color.lerp(defaultcolor, other.defaultcolor, t),
      onDefaultcolor: Color.lerp(onDefaultcolor, other.onDefaultcolor, t),
      defaultcolorContainer:
          Color.lerp(defaultcolorContainer, other.defaultcolorContainer, t),
      onDefaultcolorContainer:
          Color.lerp(onDefaultcolorContainer, other.onDefaultcolorContainer, t),
    );
  }

  /// Returns an instance of [CustomColors] in which the following custom
  /// colors are harmonized with [dynamic]'s [ColorScheme.primary].
  ///   * [CustomColors.sourceDefaultcolor]
  ///   * [CustomColors.defaultcolor]
  ///   * [CustomColors.onDefaultcolor]
  ///   * [CustomColors.defaultcolorContainer]
  ///   * [CustomColors.onDefaultcolorContainer]
  ///
  /// See also:
  ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors#harmonization>
  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(
      sourceDefaultcolor: sourceDefaultcolor!.harmonizeWith(dynamic.primary),
      defaultcolor: defaultcolor!.harmonizeWith(dynamic.primary),
      onDefaultcolor: onDefaultcolor!.harmonizeWith(dynamic.primary),
      defaultcolorContainer:
          defaultcolorContainer!.harmonizeWith(dynamic.primary),
      onDefaultcolorContainer:
          onDefaultcolorContainer!.harmonizeWith(dynamic.primary),
    );
  }
}
