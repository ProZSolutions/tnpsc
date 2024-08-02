class Meta {
  late int statusCode;
  late String statusMsg;
  late Map<String,dynamic> response=new Map<String,dynamic>();

  Meta({this.statusCode=0, this.statusMsg="",this.response= const {} });

  Meta.fromJson(Map<String, dynamic> json) {
    statusCode = json["statusCode"];
    statusMsg = json['statusMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['statusMsg'] = this.statusMsg;
    return data;
  }}