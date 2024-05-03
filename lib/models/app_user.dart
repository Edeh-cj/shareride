class AppUser {
  final String name, uid, phonenumber;
  final int balance;

  AppUser({required this.balance, required this.name, required this.uid, required this.phonenumber});

  AppUser.fromFirestore(Map<String, dynamic> data):
    name = data['name'],
    uid = data['uid'],
    phonenumber = data['phonenumber'],
    balance = data['balance'];
    

  AppUser.dummy():
    name = '-',
    uid = 'awedgr',
    balance = 0,
    phonenumber = '08099999999';
}