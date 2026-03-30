class Event {
  final int id;
  final String title;
  final String description;
  final String venue;
  final String city;
  final String eventDate;
  final String? eventTime;
  final String? image;
  final String ticketUrl;
  final bool isFree;
  final bool isUpcoming;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.venue,
    required this.city,
    required this.eventDate,
    this.eventTime,
    this.image,
    required this.ticketUrl,
    required this.isFree,
    required this.isUpcoming,
  });

  factory Event.fromJson(Map<String, dynamic> j) => Event(
        id: j['id'],
        title: j['title'],
        description: j['description'],
        venue: j['venue'],
        city: j['city'] ?? '',
        eventDate: j['event_date'],
        eventTime: j['event_time'],
        image: j['image'],
        ticketUrl: j['ticket_url'] ?? '',
        isFree: j['is_free'] ?? false,
        isUpcoming: j['is_upcoming'] ?? false,
      );
}
