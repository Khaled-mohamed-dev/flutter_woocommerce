import 'dart:convert';

List<Coupon> couponsFromJson(String str) =>
    List<Coupon>.from(json.decode(str).map((x) => Coupon.fromJson(x)));

class Coupon {
  final int id;
  final String code;
  final String amount;
  final String discountType;
  final String description;
  final dynamic dateExpires;
  final int usageCount;
  final bool individualUse;
  final List<dynamic> productIds;
  final List<dynamic> excludedProductIds;
  final dynamic usageLimit;
  final dynamic usageLimitPerUser;
  final dynamic limitUsageToXItems;
  final bool freeShipping;
  final List<dynamic> productCategories;
  final List<dynamic> excludedProductCategories;
  final bool excludeSaleItems;
  final String minimumAmount;
  final String maximumAmount;
  final List<dynamic> emailRestrictions;
  final List<dynamic> usedBy;

  Coupon({
    required this.id,
    required this.code,
    required this.amount,
    required this.discountType,
    required this.description,
    required this.dateExpires,
    required this.usageCount,
    required this.individualUse,
    required this.productIds,
    required this.excludedProductIds,
    required this.usageLimit,
    required this.usageLimitPerUser,
    required this.limitUsageToXItems,
    required this.freeShipping,
    required this.productCategories,
    required this.excludedProductCategories,
    required this.excludeSaleItems,
    required this.minimumAmount,
    required this.maximumAmount,
    required this.emailRestrictions,
    required this.usedBy,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json["id"],
        code: json["code"],
        amount: json["amount"],
        discountType: json["discount_type"],
        description: json["description"],
        dateExpires: json["date_expires"],
        usageCount: json["usage_count"],
        individualUse: json["individual_use"],
        productIds: List<dynamic>.from(json["product_ids"].map((x) => x)),
        excludedProductIds:
            List<dynamic>.from(json["excluded_product_ids"].map((x) => x)),
        usageLimit: json["usage_limit"],
        usageLimitPerUser: json["usage_limit_per_user"],
        limitUsageToXItems: json["limit_usage_to_x_items"],
        freeShipping: json["free_shipping"],
        productCategories:
            List<dynamic>.from(json["product_categories"].map((x) => x)),
        excludedProductCategories: List<dynamic>.from(
            json["excluded_product_categories"].map((x) => x)),
        excludeSaleItems: json["exclude_sale_items"],
        minimumAmount: json["minimum_amount"],
        maximumAmount: json["maximum_amount"],
        emailRestrictions:
            List<dynamic>.from(json["email_restrictions"].map((x) => x)),
        usedBy: List<dynamic>.from(json["used_by"].map((x) => x)),
      );
}
