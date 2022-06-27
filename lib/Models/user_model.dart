

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
    UserData({
        this.page,
        this.perPage,
        this.total,
        this.totalPages,
        this.data,
    });

    int? page;
    int? perPage;
    int? total;
    int ?totalPages;
    List<Users>? data;

    factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        page: json["page"],
        perPage: json["per_page"],
        total: json["total"],
        totalPages: json["total_pages"],
        data: List<Users>.from(json["data"].map((x) => Users.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "per_page": perPage,
        "total": total,
        "total_pages": totalPages,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Users {
    Users({
        this.id,
        this.email,
        this.firstName,
        this.lastName,
        this.avatar,
    });

    int? id;
    String? email;
    String? firstName;
    String? lastName;
    String? avatar;

    factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
    };
}
