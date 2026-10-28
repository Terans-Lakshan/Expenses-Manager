/// Default categories and wallets seeded on first launch (PRD section 6).
class DefaultCategory {
  final String type, name, icon, bg, fg;
  final int order;
  final bool locked;
  const DefaultCategory(this.type, this.name, this.icon, this.bg, this.fg,
      this.order,
      {this.locked = false});
}

class DefaultWallet {
  final String name, icon;
  const DefaultWallet(this.name, this.icon);
}

const defaultCategories = <DefaultCategory>[
  DefaultCategory('expense', 'Food & dining', 'utensils', '#FDE9DC', '#B4471A', 0),
  DefaultCategory('expense', 'Groceries', 'shopping-cart', '#E4F4DD', '#3C7A1E', 1),
  DefaultCategory('expense', 'Transport', 'car', '#E1ECFB', '#1D5FCC', 2),
  DefaultCategory('expense', 'Bills & utilities', 'receipt', '#FFF2CC', '#8A6100', 3),
  DefaultCategory('expense', 'Rent & housing', 'home', '#E6EAF0', '#3B4A5E', 4),
  DefaultCategory('expense', 'Shopping', 'shopping-bag', '#F6E3F1', '#9B2F7E', 5),
  DefaultCategory('expense', 'Health', 'heart-pulse', '#FBE2E4', '#B42335', 6),
  DefaultCategory('expense', 'Entertainment', 'play-circle', '#ECE6FB', '#5B3CC4', 7),
  DefaultCategory('expense', 'Education', 'graduation-cap', '#DFF3F0', '#0F7468', 8),
  DefaultCategory('expense', 'Other', 'more-horizontal', '#ECEEF1', '#4A5361', 9,
      locked: true),
  DefaultCategory('income', 'Salary', 'briefcase', '#DCEBFF', '#1652B8', 0),
  DefaultCategory('income', 'Freelance', 'laptop', '#DDF1F4', '#0E6E7E', 1),
  DefaultCategory('income', 'Business', 'store', '#E9E4FA', '#4D35B0', 2),
  DefaultCategory('income', 'Investments', 'trending-up', '#DDF3E6', '#1C7A44', 3),
  DefaultCategory('income', 'Gifts', 'gift', '#FCE4EC', '#B0245C', 4),
  DefaultCategory('income', 'Refunds', 'rotate-ccw', '#E6EAF0', '#3B4A5E', 5),
  DefaultCategory('income', 'Other income', 'more-horizontal', '#ECEEF1', '#4A5361', 6,
      locked: true),
];

const defaultWallets = <DefaultWallet>[
  DefaultWallet('Cash', 'cash'),
  DefaultWallet('Bank', 'bank'),
  DefaultWallet('Card', 'card'),
  DefaultWallet('e-Wallet', 'phone'),
];

/// Tile / icon colour pairs offered when creating or recolouring a category.
const categoryColorPairs = <(String, String)>[
  ('#FDE9DC', '#B4471A'),
  ('#E4F4DD', '#3C7A1E'),
  ('#E1ECFB', '#1D5FCC'),
  ('#FFF2CC', '#8A6100'),
  ('#E6EAF0', '#3B4A5E'),
  ('#F6E3F1', '#9B2F7E'),
  ('#FBE2E4', '#B42335'),
  ('#ECE6FB', '#5B3CC4'),
  ('#DFF3F0', '#0F7468'),
  ('#DDF3E6', '#1C7A44'),
  ('#FCE4EC', '#B0245C'),
  ('#ECEEF1', '#4A5361'),
];
