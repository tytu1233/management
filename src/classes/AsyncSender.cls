global class AsyncSender {
    public static void asyncWork() {
		Lead lead = new Lead();
        
        for(Integer i = 0; i < 5; i++) {
            lead.put('e', 'e');
        }
        insert lead;
    }
    
    public static void getContacts() {
        List<Contact> contacts = [
                SELECT Id
                FROM Contact
        ];
    
        for(Contact con : contacts) {
            asyncWork();
        }
	}
}