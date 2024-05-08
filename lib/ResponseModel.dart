class ResponseModel {
  ResponseModel({
      this.sentence,});

  ResponseModel.fromJson(dynamic json) {
    sentence = json['sentence'] != null ? json['sentence'].cast<String>() : [];
  }
  List<String>? sentence;

  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['sentence'] = sentence;
  //   return map;
  // }

}