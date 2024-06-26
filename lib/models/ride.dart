
class Ride {
  final String id, docid, from, to, region, time, creator, creatorid, remainingPassengersText;
  final int price;
  final List participants;
  final bool isComplete, isLocked;

  Ride({
    required this.creator, 
    required this.creatorid, 
    required this.id, 
    required this.docid,
    required this.from, 
    required this.to, 
    required this.region, 
    required this.time, 
    required this.price, 
    required this.isLocked,
    required this.participants,
  }): 
  isComplete = participants.length == 7,
  remainingPassengersText = (participants.length == 7)? 'Complete!' : 'Awaiting Fill'
  ;

  
  Ride.custom(int remainingPassengers, this.region, String uid):
    id = '08BC',
    docid = 'hdladgblkkh',
    from = 'Chizaram lodge',
    to = 'Pharm., Jimbaz, Engr.',
    creator = 'Harry',
    creatorid = 'd5r5g4tg5s5gtg5sbh5jhsk',
    isLocked = false,
    time = '8am',
    price = 160,
    participants = ['ljdbfhaflubafk', 'kajbfjsfbehf', 'hbafkjsdfha', 'kasfahfasj' ],
    isComplete = remainingPassengers == 0,
  remainingPassengersText = (remainingPassengers == 0)? 'Complete!' : 'Awaiting Fill';

}