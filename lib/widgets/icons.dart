import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app/theme.dart';

/// 24×24 stroke icon bodies (SVG children), taken from the prototype's
/// tpl-CatIcon and nav icons.
const iconPaths = <String, String>{
  // category icons
  'utensils':
      '<path d="M6 3v6a3 3 0 0 0 6 0V3"/><path d="M9 3v18"/><path d="M18 21V3c-2 1.5-3 4-3 7h3"/>',
  'car':
      '<rect x="3" y="11" width="18" height="6" rx="2"/><path d="M5 11l2-5h10l2 5"/><circle cx="7.5" cy="17.5" r="1.5"/><circle cx="16.5" cy="17.5" r="1.5"/>',
  'shopping-bag': '<path d="M5 8h14l-1 13H6L5 8z"/><path d="M9 8V6a3 3 0 0 1 6 0v2"/>',
  'receipt': '<path d="M6 3h12v18l-3-2-3 2-3-2-3 2V3z"/><path d="M9 8h6"/><path d="M9 12h6"/>',
  'heart-pulse':
      '<path d="M20.8 8.6a5 5 0 0 0-8.8-3.2 5 5 0 0 0-8.8 3.2c0 5.4 8.8 11 8.8 11s8.8-5.6 8.8-11z"/><path d="M8 11h2l1-2 2 4 1-2h2"/>',
  'play-circle': '<circle cx="12" cy="12" r="9"/><path d="M10 8.5l5 3.5-5 3.5z"/>',
  'graduation-cap': '<path d="M2 9l10-5 10 5-10 5-10-5z"/><path d="M6 11v5c3 2 9 2 12 0v-5"/>',
  'home': '<path d="M3 11l9-7 9 7"/><path d="M5 10v10h14V10"/><path d="M10 20v-6h4v6"/>',
  'shopping-cart':
      '<circle cx="9" cy="20" r="1.5"/><circle cx="18" cy="20" r="1.5"/><path d="M2 3h3l2.5 12h12L22 7H6.2"/>',
  'more-horizontal':
      '<circle cx="5" cy="12" r="1"/><circle cx="12" cy="12" r="1"/><circle cx="19" cy="12" r="1"/>',
  'briefcase': '<rect x="3" y="7" width="18" height="13" rx="2"/><path d="M9 7V5h6v2"/><path d="M3 13h18"/>',
  'laptop': '<rect x="4" y="5" width="16" height="11" rx="1.5"/><path d="M2 19h20"/>',
  'store': '<path d="M4 10v10h16V10"/><path d="M3 10l2-6h14l2 6z"/><path d="M10 20v-5h4v5"/>',
  'trending-up': '<path d="M3 17l6-6 4 4 8-8"/><path d="M15 7h6v6"/>',
  'gift':
      '<rect x="3" y="8" width="18" height="4" rx="1"/><path d="M5 12v9h14v-9"/><path d="M12 8v13"/><path d="M12 8C10 4 6 4 6 6.5S9 8 12 8z"/><path d="M12 8c2-4 6-4 6-1.5S15 8 12 8z"/>',
  'rotate-ccw': '<path d="M3 12a9 9 0 1 0 3-6.7L3 8"/><path d="M3 3v5h5"/>',
  // extra icons for custom categories and wallets
  'coffee':
      '<path d="M4 8h13v6a5 5 0 0 1-5 5H9a5 5 0 0 1-5-5V8z"/><path d="M17 10h1.5a2.5 2.5 0 0 1 0 5H17"/><path d="M8 2v3"/><path d="M12 2v3"/>',
  'phone': '<rect x="7" y="2" width="10" height="20" rx="2"/><path d="M11 18h2"/>',
  'plane': '<path d="M22 2L11 13"/><path d="M22 2l-7 20-4-9-9-4 20-7z"/>',
  'dumbbell': '<path d="M6 7v10"/><path d="M18 7v10"/><path d="M3 10v4"/><path d="M21 10v4"/><path d="M6 12h12"/>',
  'book':
      '<path d="M4 4h6a2 2 0 0 1 2 2v14a2 2 0 0 0-2-2H4z"/><path d="M20 4h-6a2 2 0 0 0-2 2v14a2 2 0 0 1 2-2h6z"/>',
  'cash': '<rect x="2" y="6" width="20" height="12" rx="2"/><circle cx="12" cy="12" r="2.5"/>',
  'card': '<rect x="2" y="5" width="20" height="14" rx="2"/><path d="M2 10h20"/>',
  'bank': '<path d="M3 10l9-6 9 6"/><path d="M5 10v8"/><path d="M9 10v8"/><path d="M15 10v8"/><path d="M19 10v8"/><path d="M3 21h18"/>',
  'wallet': '<rect x="3" y="6" width="18" height="14" rx="2"/><path d="M3 10h18"/><circle cx="16" cy="15" r="1"/>',
  // UI icons
  'search': '<circle cx="11" cy="11" r="7"/><path d="M20 20l-3.5-3.5"/>',
  'bell': '<path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.9 1.9 0 0 0 3.4 0"/>',
  'chevron-left': '<path d="M15 6l-6 6 6 6"/>',
  'chevron-right': '<path d="M9 6l6 6-6 6"/>',
  'arrow-down': '<path d="M12 5v14"/><path d="M6 13l6 6 6-6"/>',
  'arrow-up': '<path d="M12 19V5"/><path d="M6 11l6-6 6 6"/>',
  'nav-home': '<path d="M3 11l9-7 9 7v9a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z"/>',
  'nav-list':
      '<path d="M8 6h13"/><path d="M8 12h13"/><path d="M8 18h13"/><path d="M3.5 6h.01"/><path d="M3.5 12h.01"/><path d="M3.5 18h.01"/>',
  'nav-reports': '<path d="M21 12A9 9 0 1 1 12 3v9z"/><path d="M15 3.5A9 9 0 0 1 20.5 9H15z"/>',
  'nav-more':
      '<rect x="3" y="3" width="7" height="7" rx="1.5"/><rect x="14" y="3" width="7" height="7" rx="1.5"/><rect x="3" y="14" width="7" height="7" rx="1.5"/><rect x="14" y="14" width="7" height="7" rx="1.5"/>',
  'plus': '<path d="M12 5v14"/><path d="M5 12h14"/>',
  'close': '<path d="M6 6l12 12"/><path d="M18 6L6 18"/>',
  'check': '<path d="M5 12l5 5 9-10"/>',
  'calendar':
      '<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 10h18"/><path d="M8 3v4"/><path d="M16 3v4"/>',
  'pencil': '<path d="M4 20h4L19 9l-4-4L4 16v4z"/>',
  'camera': '<path d="M4 8h3l2-3h6l2 3h3v11H4z"/><circle cx="12" cy="13" r="3.5"/>',
  'repeat':
      '<path d="M17 2l4 4-4 4"/><path d="M3 11V9a3 3 0 0 1 3-3h15"/><path d="M7 22l-4-4 4-4"/><path d="M21 13v2a3 3 0 0 1-3 3H3"/>',
  'download': '<path d="M12 3v12"/><path d="M7 10l5 5 5-5"/><path d="M4 21h16"/>',
  'grip':
      '<circle cx="9" cy="6" r="1"/><circle cx="15" cy="6" r="1"/><circle cx="9" cy="12" r="1"/><circle cx="15" cy="12" r="1"/><circle cx="9" cy="18" r="1"/><circle cx="15" cy="18" r="1"/>',
  'trash': '<path d="M4 7h16"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M6 7l1 13h10l1-13"/><path d="M9 7V4h6v3"/>',
  'pie': '<path d="M21 12A9 9 0 1 1 12 3v9z"/><path d="M15 3.5A9 9 0 0 1 20.5 9H15z"/>',
  'tag': '<path d="M3 12V4h8l10 10-8 8L3 12z"/><circle cx="7.5" cy="8.5" r="1.5"/>',
  'lock': '<rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/>',
  'upload': '<path d="M12 21V9"/><path d="M7 14l5-5 5 5"/><path d="M4 3h16"/>',
  'database': '<ellipse cx="12" cy="5" rx="8" ry="3"/><path d="M4 5v14c0 1.7 3.6 3 8 3s8-1.3 8-3V5"/><path d="M4 12c0 1.7 3.6 3 8 3s8-1.3 8-3"/>',
  'image': '<rect x="3" y="4" width="18" height="16" rx="2"/><circle cx="9" cy="10" r="2"/><path d="M21 17l-5-5-9 8"/>',
};

/// Icons a user can choose for a category.
const categoryIconChoices = [
  'utensils', 'shopping-cart', 'car', 'receipt', 'home', 'shopping-bag',
  'heart-pulse', 'play-circle', 'graduation-cap', 'briefcase', 'laptop', 'store',
  'trending-up', 'gift', 'rotate-ccw', 'coffee', 'phone', 'plane', 'dumbbell',
  'book', 'cash', 'card', 'bank', 'wallet', 'tag', 'more-horizontal',
];

const walletIconChoices = ['cash', 'bank', 'card', 'phone', 'wallet', 'briefcase'];

String _hex(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

/// A stroke icon drawn from [iconPaths].
class AppIcon extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;
  final double? strokeWidth;
  final String? semanticLabel;

  const AppIcon(this.name,
      {super.key, this.size = 20, this.color, this.strokeWidth, this.semanticLabel});

  @override
  Widget build(BuildContext context) {
    final c = color ?? IconTheme.of(context).color ?? context.pal.text;
    final body = iconPaths[name] ?? iconPaths['more-horizontal']!;
    final sw = strokeWidth ?? (name == 'more-horizontal' || name == 'grip' ? 2.2 : 2.0);
    final svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" '
        'stroke="${_hex(c)}" stroke-width="$sw" stroke-linecap="round" '
        'stroke-linejoin="round">$body</svg>';
    final pic = SvgPicture.string(svg, width: size, height: size);
    return semanticLabel == null
        ? ExcludeSemantics(child: pic)
        : Semantics(label: semanticLabel, child: pic);
  }
}

/// Category icon on a tinted tile; tile radius is 32% of its size.
class CatIcon extends StatelessWidget {
  final String icon;
  final String bg, fg;
  final double size;
  const CatIcon({super.key, required this.icon, required this.bg, required this.fg, this.size = 44});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: hexColor(bg), borderRadius: BorderRadius.circular(size * 0.32)),
        child: AppIcon(icon,
            size: size * 0.5,
            color: hexColor(fg),
            strokeWidth: icon == 'more-horizontal' ? 2.2 : 1.9),
      );
}
