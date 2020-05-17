import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.OneToMany;
import java.util.LinkedHashSet;
import java.util.Set;

@Entity
public class Supplier extends Company {

    private String bankAccountNumber;

    @OneToMany(mappedBy = "supplier", cascade = CascadeType.PERSIST)
    private Set<Product> products = new LinkedHashSet<>();

    public Supplier() {
        super();
    }

    public Supplier(String companyName, String street, String city, String zipCode, String bankAccountNumber){
        super(companyName, street, city, zipCode);
        this.bankAccountNumber = bankAccountNumber;
    }

    public void addProduct(Product product){
        this.products.add(product);
    }
}

