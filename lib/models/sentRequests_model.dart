import 'dart:convert';

List<SentRequestsResponse> sentRequestsResponseFromJson(String str) => List<SentRequestsResponse>.from(json.decode(str).map((x) => SentRequestsResponse.fromJson(x)));

String sentRequestsResponseToJson(List<SentRequestsResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SentRequestsResponse {
    SentRequestsResponse({
        this.image,
        this.id,
        this.name,
    });

    String image;
    String id;
    String name;

    factory SentRequestsResponse.fromJson(Map<String, dynamic> json) => SentRequestsResponse(
        image: json["image"],
        id: json["_id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "_id": id,
        "name": name,
    };
}
