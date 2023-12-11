import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestService {
  static Future<int> getFriendRequestsCount(String userUid) async {
    QuerySnapshot<Map<String, dynamic>> requestSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userUid)
            .collection('requests')
            .where('pending', isEqualTo: true)
            .get();

    if (requestSnapshot.docs.isNotEmpty) {
      List<Map<String, dynamic>> requestsDataList = requestSnapshot.docs
          .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Filter out accepted friend requests
      requestsDataList = requestsDataList
          .where((request) =>
              !request.containsKey('accepted') ||
              request['accepted'] != true && request['block'] != true)
          .toList();

      return requestsDataList.length;
    } else {
      return 0;
    }
  }
}
