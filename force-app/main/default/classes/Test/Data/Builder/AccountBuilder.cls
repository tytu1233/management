/**
 * Created by patryk.witkowski_bri on 5/23/2025.
 */

public class AccountBuilder {

    private final Account account;

    public AccountBuilder() {
        this.account = new Account();
        this.account.Name = 'Test account name';
    }

    public AccountBuilder name(String name) {
        this.account.Name = name;
        return this;
    }

    public AccountBuilder save() {
        insert this.account;
        return this;
    }

    public Account build() {
        return this.account;
    }

}