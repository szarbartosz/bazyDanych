import javax.persistence.*;

@Entity
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public class Company {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int CompanyID;

    private String CompanyName;
    private String Street;
    private String City;
    private String ZipCode;

    public Company() {}

    public Company(String companyName, String street, String city, String zipCode) {
        this.CompanyName = companyName;
        this.Street = street;
        this.City = city;
        this.ZipCode = zipCode;
    }
}