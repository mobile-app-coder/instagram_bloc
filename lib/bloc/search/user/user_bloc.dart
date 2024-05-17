import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/member_model.dart';
import '../../../services/db_service.dart';
import '../../../services/http_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<FollowEvent>(_apiFollowMember);
    on<UnFollowEvent>(_apiUnFollowMember);
  }

  Future<void> _apiFollowMember(
      FollowEvent event, Emitter<UserState> emit) async {
    await DBService.followMember(event.member);
    event.member.followed = true;
    DBService.storePostsToMyFeed(event.member);
    sendNotificationToFollowedMember(event.member);
    emit(FollowedState());
  }

  Future<void> _apiUnFollowMember(
      UnFollowEvent event, Emitter<UserState> emit) async {
    await DBService.unfollowMember(event.member);

    event.member.followed = false;

    DBService.removePostsFromMyFeed(event.member);
    emit(UnFollowedState());
  }

  void sendNotificationToFollowedMember(Member someone) async {
    Member me = await DBService.loadMember();
    await Network.POST(
        Network.API_SEND_NOTIF, Network.paramsNotify(me, someone));
  }
}
