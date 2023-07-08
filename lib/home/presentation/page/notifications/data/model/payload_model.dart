enum notificationType { friend_request, react, post, comment }

class PayloadModel {
  String? data;
  int? id;
  String? type;
  String? clickAction;
  String? status;

  PayloadModel({this.data, this.id, this.type, this.clickAction, this.status});

  PayloadModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    id = json['id'];
    type = json['type'];
    clickAction = json['click_action'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    data['id'] = id;
    data['type'] = type;
    data['click_action'] = clickAction;
    data['status'] = status;
    return data;
  }
}
