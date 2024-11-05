class SiteContactCreateData {
  String? firstname;
  String? lastname;
  String? email;
  String? mobile;
  String? deliveryAddressId;

  SiteContactCreateData(
      {this.firstname,
      this.lastname,
      this.email,
      this.mobile,
      this.deliveryAddressId});

  Map<String, dynamic> toJson() => {
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "email": email == null ? null : email,
        "mobile": mobile == null ? null : mobile,
        "delivery_address_id":
            deliveryAddressId == null ? null : deliveryAddressId,
      };
}
