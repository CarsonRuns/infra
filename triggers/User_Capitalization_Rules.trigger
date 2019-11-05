trigger User_Capitalization_Rules on User (before insert, before update) {
    TriggerHandler.execute(User_Capitalization_Rules.class);

}