class SalesItem {
  final String name, postedBy, posterUid;
  final int price;
  final bool isBargainable;

  SalesItem({required this.name, required this.posterUid, required this.postedBy, required this.price, required this.isBargainable});
  SalesItem.dummy(this.isBargainable):
  name = 'Kitchen accessories and table',
  postedBy = 'Amaka',
  posterUid = '',
  price = 3500;
}