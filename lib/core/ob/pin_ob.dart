
import '../../builders/factory/factory_builder.dart';

class PnObClass<T extends Object?> {
  List<T?>? data;
  Links? links;
  Meta? meta;
  int? result;
  String? message;
  String? pageImage;

  PnObClass({this.data, this.links, this.meta, this.result, this.message, this.pageImage});

  PnObClass.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <T>[];
      json['data'].forEach((v) {
        data!.add(objectFactories[T]!(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    result = json['result'];
    message = json['message'];
    pageImage = json['page_image'].toString();
  }

//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    if (this.data != null) {
//      data['data'] = this.data.map((v) => v.toJson()).toList();
//    }
//    if (this.links != null) {
//      data['links'] = this.links.toJson();
//    }
//    if (this.meta != null) {
//      data['meta'] = this.meta.toJson();
//    }
//    data['result'] = this.result;
//    data['message'] = this.message;
//    return data;
//  }
}

class Links {
  String? first;
  String? last;
  String? prev;
  String? next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'].toString();
    next = json['next'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  String? path;
  int? perPage;
  int? to;
  String? total;

  Meta({this.currentPage, this.from, this.lastPage, this.path, this.perPage, this.to, this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}
