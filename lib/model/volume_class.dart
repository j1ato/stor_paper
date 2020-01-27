// Parses data from firebase into volume contsructor

class Volume {
  const Volume({
    this.id,
    this.productID,
    this.volumeTitle,
    this.image,
    this.numberOfStories,
    this.stories,
  });

  Volume.fromMap(Map<String, dynamic> data, String id)
      : this(
          id: id,
          productID: data['productID'],
          volumeTitle: data['volumeTitle'],
          image: data['image'],
          numberOfStories: data['numberOfStories'],
          stories: List<Map>.from(data['stories']),
        );

  final String id;
  final String productID;
  final String volumeTitle;
  final String image;
  final String numberOfStories;
  final List<Map> stories;
}


