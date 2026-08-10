class KitchenIngredient {
  final int id; // user_kitchen row id
  final int ingredientId;
  final String name;
  final String category;
  final num quantity;
  final String unit;
  final String? expirationDate;

  KitchenIngredient({
    required this.id,
    required this.ingredientId,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    this.expirationDate,
  });

  factory KitchenIngredient.fromJson(Map<String, dynamic> json) {
    return KitchenIngredient(
      id: json['id'] as int,
      ingredientId: json['ingredient_id'] as int,
      name: json['name'] as String,
      category: json['category'] as String? ?? 'Other',
      quantity: json['quantity'] ?? 1,
      unit: json['unit'] as String? ?? 'pieces',
      expirationDate: json['expiration_date'] as String?,
    );
  }
}
