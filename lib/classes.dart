class TrafficMainJSON {
  final List<TrafficJSON> items;

  TrafficMainJSON({this.items});

  factory TrafficMainJSON.fromJson(Map<String, dynamic> json) {
    var items = json['items'] as List;
    List<TrafficJSON> trafficList = items.map((i) => TrafficJSON.fromJson(i)).toList();
    return TrafficMainJSON(
      items: trafficList,
    );
  }
}

class TrafficJSON {
  final String timestamp;
  final List<Camera> cameras;

  TrafficJSON({this.timestamp,this.cameras});
  
  factory TrafficJSON.fromJson(Map<String, dynamic> json) {
    var cameras = json['cameras'] as List;
    List<Camera> cameralist = cameras.map((i) => Camera.fromJson(i)).toList();
    return TrafficJSON(
      timestamp: json['timestamp'],
      cameras: cameralist,
    );
  }
}

class Camera {
  final String timestamp;
  final String image;
  final double latitude;
  final double longitude;
  final String camera_id;

  Camera({this.timestamp, this.image, this.latitude, this.longitude,this.camera_id});

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      timestamp: json['timestamp'],
      image: json['image'],
      // latitude: json['image'],
      // longitude: json['image'],
      latitude: json['location']['latitude'],
      longitude: json['location']['longitude'],
      camera_id:json['camera_id'],
    );
  }
}
