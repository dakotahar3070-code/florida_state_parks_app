class Park {
  final int id;
  final String name;
  final String description;
  final String bookingUrl;

  Park({
    required this.id,
    required this.name,
    required this.description,
    required this.bookingUrl,
  });

  factory Park.fromJson(Map<String, dynamic> json) {
    return Park(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      bookingUrl: json['booking_url'],
    );
  }
}
