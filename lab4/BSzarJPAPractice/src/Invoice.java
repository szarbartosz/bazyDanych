import javax.persistence.*;
import java.util.LinkedHashSet;
import java.util.Set;

@Entity
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int InvoiceNumber;
    private int Quantity;

    @ManyToMany(cascade = CascadeType.PERSIST)
    private Set<Product> products = new LinkedHashSet<>();

    public Invoice() {}

    public Invoice(int Quantity){
        this.Quantity = Quantity;
    }

    public void addProduct(Product product) {
        this.products.add(product);
    }

    public Set<Product> getProducts() {
        return this.products;
    }

    @Override
    public String toString() {
        return "Invoice(InvoiceNumber: " + InvoiceNumber + ", Quantity: " + Quantity + "Products" + products + ")";
    }
}
