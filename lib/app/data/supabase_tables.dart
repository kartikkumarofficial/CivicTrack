class SupabaseTables {
  static const String users = 'users';
  static const String chats = 'chats';
  static const String messages = 'messages';
  static const String chatMembers = 'chat_members';
}

class SupabaseColumns {
  // Users table
  static const String userId = 'id';
  static const String username = 'username';
  static const String email = 'email';
  static const String profileImage = 'profile_image';

  // Chats table
  static const String chatId = 'id';
  static const String chatType = 'type';
  static const String chatName = 'name';

  // Messages table
  static const String messageId = 'id';
  static const String chatIdFK = 'chat_id';
  static const String senderId = 'sender_id';
  static const String content = 'content';
  static const String fileUrl = 'file_url';
  static const String messageType = 'type';
  static const String sentAt = 'sent_at';

  // Chat Members table
  static const String chatMemberChatId = 'chat_id';
  static const String chatMemberUserId = 'user_id';
  static const String joinedAt = 'joined_at';
}