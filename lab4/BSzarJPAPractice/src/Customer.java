import javax.persistence.Entity;

@Entity
public class Customer extends Company {
    private int Discount;

    public Customer() {
        super();
    }

    public Customer(String companyName, String street, String city, String zipCode, int discount) {
        super(companyName, street, city, zipCode);
        this.Discount = discount;
    }
}