// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

import '../../../authentication/data/models/user.dart';

List<Order> ordersFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  final int? id;
  final int? parentId;
  final String? number;
  final String? orderKey;
  final String? createdVia;
  final String? version;
  final String? status;
  final String? currency;
  final DateTime? dateCreated;
  final String? discountTotal;
  final String? discountTax;
  final String? shippingTotal;
  final String? shippingTax;
  final String? cartTax;
  final String? total;
  final String? totalTax;
  final bool? pricesIncludeTax;
  final int customerId;
  final String? customerNote;
  final Ing billing;
  final Ing shipping;
  final String paymentMethod;
  final String paymentMethodTitle;
  final String? transactionId;
  final DateTime? datePaid;
  final dynamic dateCompleted;
  final List<LineItem> lineItems;
  final List<TaxLine>? taxLines;
  final List<ShippingLine>? shippingLines;
  final List<dynamic>? feeLines;
  final List<dynamic>? couponLines;
  final List<dynamic>? refunds;

  Order({
    this.id,
    this.parentId,
    this.number,
    this.orderKey,
    this.createdVia,
    this.version,
    this.status,
    this.currency = 'EGP',
    this.dateCreated,
    this.discountTotal,
    this.discountTax,
    this.shippingTotal,
    this.shippingTax,
    this.cartTax,
    this.total,
    this.totalTax,
    this.pricesIncludeTax,
    required this.customerId,
    this.customerNote,
    required this.billing,
    required this.shipping,
    required this.paymentMethod,
    required this.paymentMethodTitle,
    this.transactionId,
    this.datePaid,
    this.dateCompleted,
    required this.lineItems,
    this.taxLines,
    this.shippingLines,
    this.feeLines,
    this.couponLines,
    this.refunds,
  });

  Order copyWith({
    int? id,
    int? parentId,
    String? number,
    String? orderKey,
    String? createdVia,
    String? version,
    String? status,
    String? currency,
    DateTime? dateCreated,
    String? discountTotal,
    String? discountTax,
    String? shippingTotal,
    String? shippingTax,
    String? cartTax,
    String? total,
    String? totalTax,
    bool? pricesIncludeTax,
    int? customerId,
    String? customerNote,
    Ing? billing,
    Ing? shipping,
    String? paymentMethod,
    String? paymentMethodTitle,
    String? transactionId,
    DateTime? datePaid,
    dynamic dateCompleted,
    List<LineItem>? lineItems,
    List<TaxLine>? taxLines,
    List<ShippingLine>? shippingLines,
    List<dynamic>? feeLines,
    List<dynamic>? couponLines,
    List<dynamic>? refunds,
  }) =>
      Order(
        id: id ?? this.id,
        parentId: parentId ?? this.parentId,
        number: number ?? this.number,
        orderKey: orderKey ?? this.orderKey,
        createdVia: createdVia ?? this.createdVia,
        version: version ?? this.version,
        status: status ?? this.status,
        currency: currency ?? this.currency,
        dateCreated: dateCreated ?? this.dateCreated,
        discountTotal: discountTotal ?? this.discountTotal,
        discountTax: discountTax ?? this.discountTax,
        shippingTotal: shippingTotal ?? this.shippingTotal,
        shippingTax: shippingTax ?? this.shippingTax,
        cartTax: cartTax ?? this.cartTax,
        total: total ?? this.total,
        totalTax: totalTax ?? this.totalTax,
        pricesIncludeTax: pricesIncludeTax ?? this.pricesIncludeTax,
        customerId: customerId ?? this.customerId,
        customerNote: customerNote ?? this.customerNote,
        billing: billing ?? this.billing,
        shipping: shipping ?? this.shipping,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        paymentMethodTitle: paymentMethodTitle ?? this.paymentMethodTitle,
        transactionId: transactionId ?? this.transactionId,
        datePaid: datePaid ?? this.datePaid,
        dateCompleted: dateCompleted ?? this.dateCompleted,
        lineItems: lineItems ?? this.lineItems,
        taxLines: taxLines ?? this.taxLines,
        shippingLines: shippingLines ?? this.shippingLines,
        feeLines: feeLines ?? this.feeLines,
        couponLines: couponLines ?? this.couponLines,
        refunds: refunds ?? this.refunds,
      );

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        parentId: json["parent_id"],
        number: json["number"],
        orderKey: json["order_key"],
        createdVia: json["created_via"],
        version: json["version"],
        status: json["status"],
        currency: json["currency"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        discountTotal: json["discount_total"],
        discountTax: json["discount_tax"],
        shippingTotal: json["shipping_total"],
        shippingTax: json["shipping_tax"],
        cartTax: json["cart_tax"],
        total: json["total"],
        totalTax: json["total_tax"],
        pricesIncludeTax: json["prices_include_tax"],
        customerId: json["customer_id"],
        customerNote: json["customer_note"],
        billing: Ing.fromJson(json["billing"]),
        shipping: Ing.fromJson(json["shipping"]),
        paymentMethod: json["payment_method"],
        paymentMethodTitle: json["payment_method_title"],
        transactionId: json["transaction_id"],
        datePaid: json["date_paid"] == null
            ? null
            : DateTime.parse(json["date_paid"]),
        dateCompleted: json["date_completed"],
        lineItems: json["line_items"] == null
            ? []
            : List<LineItem>.from(
                json["line_items"]!.map((x) => LineItem.fromJson(x))),
        taxLines: json["tax_lines"] == null
            ? []
            : List<TaxLine>.from(
                json["tax_lines"]!.map((x) => TaxLine.fromJson(x))),
        shippingLines: json["shipping_lines"] == null
            ? []
            : List<ShippingLine>.from(
                json["shipping_lines"]!.map((x) => ShippingLine.fromJson(x))),
        feeLines: json["fee_lines"] == null
            ? []
            : List<dynamic>.from(json["fee_lines"]!.map((x) => x)),
        couponLines: json["coupon_lines"] == null
            ? []
            : List<dynamic>.from(json["coupon_lines"]!.map((x) => x)),
        refunds: json["refunds"] == null
            ? []
            : List<dynamic>.from(json["refunds"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "currency": currency,
        "customer_id": customerId,
        "customer_note": customerNote,
        "billing": billing.toJson(),
        "shipping": shipping.toJson(),
        "payment_method": paymentMethod,
        "payment_method_title": paymentMethodTitle,
        "transaction_id": transactionId,
        "line_items": List<dynamic>.from(lineItems.map((x) => x.toJson())),
        "shipping_lines": shippingLines == null
            ? []
            : List<dynamic>.from(shippingLines!.map((x) => x.toJson())),
        "coupon_lines": couponLines == null
            ? []
            : List<dynamic>.from(couponLines!.map((x) => x)),
      };
}

class LineItem {
  final int? id;
  final String? name;
  final int productId;
  final int? variationId;
  final int quantity;
  final String? taxClass;
  final String? subtotal;
  final String? subtotalTax;
  final String? total;
  final String? totalTax;
  final List<Tax>? taxes;
  final String? sku;
  final int? price;
  final List<MetaDataa>? metaData;

  LineItem({
    this.id,
    this.name,
    required this.productId,
    this.variationId,
    required this.quantity,
    this.taxClass,
    this.subtotal,
    this.subtotalTax,
    this.total,
    this.totalTax,
    this.taxes,
    this.sku,
    this.price,
    this.metaData,
  });

  LineItem copyWith({
    int? id,
    String? name,
    int? productId,
    int? variationId,
    int? quantity,
    String? taxClass,
    String? subtotal,
    String? subtotalTax,
    String? total,
    String? totalTax,
    List<Tax>? taxes,
    String? sku,
    int? price,
    List<MetaDataa>? metaData,
  }) =>
      LineItem(
        id: id ?? this.id,
        name: name ?? this.name,
        productId: productId ?? this.productId,
        variationId: variationId ?? this.variationId,
        quantity: quantity ?? this.quantity,
        taxClass: taxClass ?? this.taxClass,
        subtotal: subtotal ?? this.subtotal,
        subtotalTax: subtotalTax ?? this.subtotalTax,
        total: total ?? this.total,
        totalTax: totalTax ?? this.totalTax,
        taxes: taxes ?? this.taxes,
        sku: sku ?? this.sku,
        price: price ?? this.price,
        metaData: metaData ?? this.metaData,
      );

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        id: json["id"],
        name: json["name"],
        productId: json["product_id"],
        variationId: json["variation_id"],
        quantity: json["quantity"],
        taxClass: json["tax_class"],
        subtotal: json["subtotal"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "variation_id": variationId ?? 0,
        "quantity": quantity,
        "meta_data": metaData == null
            ? []
            : List<dynamic>.from(
                metaData!.map(
                  (x) => x.toJson(),
                ),
              ),
      };
}

class MetaDataa {
  final String key;
  final String value;

  MetaDataa({required this.key, required this.value});

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}

class Tax {
  final int? id;
  final String? total;
  final String? subtotal;

  Tax({
    this.id,
    this.total,
    this.subtotal,
  });

  Tax copyWith({
    int? id,
    String? total,
    String? subtotal,
  }) =>
      Tax(
        id: id ?? this.id,
        total: total ?? this.total,
        subtotal: subtotal ?? this.subtotal,
      );

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        id: json["id"],
        total: json["total"],
        subtotal: json["subtotal"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "total": total,
        "subtotal": subtotal,
      };
}

class ShippingLine {
  final int? id;
  final String? methodTitle;
  final String? methodId;
  final String? total;
  final String? totalTax;
  final List<dynamic>? taxes;

  ShippingLine({
    this.id,
    this.methodTitle,
    this.methodId,
    this.total,
    this.totalTax,
    this.taxes,
  });

  ShippingLine copyWith({
    int? id,
    String? methodTitle,
    String? methodId,
    String? total,
    String? totalTax,
    List<dynamic>? taxes,
  }) =>
      ShippingLine(
        id: id ?? this.id,
        methodTitle: methodTitle ?? this.methodTitle,
        methodId: methodId ?? this.methodId,
        total: total ?? this.total,
        totalTax: totalTax ?? this.totalTax,
        taxes: taxes ?? this.taxes,
      );

  factory ShippingLine.fromJson(Map<String, dynamic> json) => ShippingLine(
        id: json["id"],
        methodTitle: json["method_title"],
        methodId: json["method_id"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "method_title": methodTitle,
        "method_id": methodId,
        "total": total,
        "total_tax": totalTax,
        "taxes": taxes == null ? [] : List<dynamic>.from(taxes!.map((x) => x)),
      };
}

class TaxLine {
  final int? id;
  final String? rateCode;
  final int? rateId;
  final String? label;
  final bool? compound;
  final String? taxTotal;
  final String? shippingTaxTotal;

  TaxLine({
    this.id,
    this.rateCode,
    this.rateId,
    this.label,
    this.compound,
    this.taxTotal,
    this.shippingTaxTotal,
  });

  TaxLine copyWith({
    int? id,
    String? rateCode,
    int? rateId,
    String? label,
    bool? compound,
    String? taxTotal,
    String? shippingTaxTotal,
  }) =>
      TaxLine(
        id: id ?? this.id,
        rateCode: rateCode ?? this.rateCode,
        rateId: rateId ?? this.rateId,
        label: label ?? this.label,
        compound: compound ?? this.compound,
        taxTotal: taxTotal ?? this.taxTotal,
        shippingTaxTotal: shippingTaxTotal ?? this.shippingTaxTotal,
      );

  factory TaxLine.fromJson(Map<String, dynamic> json) => TaxLine(
        id: json["id"],
        rateCode: json["rate_code"],
        rateId: json["rate_id"],
        label: json["label"],
        compound: json["compound"],
        taxTotal: json["tax_total"],
        shippingTaxTotal: json["shipping_tax_total"],
      );
}
