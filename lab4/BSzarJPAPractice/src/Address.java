import javax.persistence.Embeddable;

@Embeddable
public class Address {
    private String street;
    private String city;

    public Address() {

    }

    public Address(String street, String city) {
        this.city = city;
        this.street = street;
    }

    @Override
    public String toString() {
        return "Address(street: " + street + ", city: " + city  + ")";
    }
}
