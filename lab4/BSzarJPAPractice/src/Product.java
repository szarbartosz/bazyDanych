import javax.persistence.*;
import java.util.LinkedHashSet;
import java.util.Set;

@Entity
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int ProductID;
    private String ProductName;
    private int UnitsInStock;

    @ManyToOne(cascade = CascadeType.PERSIST)
    @JoinColumn(name = "SupplierID_FK")
    private Supplier supplier;

    @ManyToOne(cascade = CascadeType.PERSIST)
    @JoinColumn(name = "CategoryID_FK")
    private Category category;

    @ManyToMany(mappedBy = "products", cascade = CascadeType.PERSIST)
    private Set<Invoice> invoices = new LinkedHashSet<>();

    public Product() {}

    public Product(String ProductName, int UnitsInStock) {
        this.ProductName = ProductName;
        this.UnitsInStock = UnitsInStock;
    }

    public void setSupplier(Supplier supplier){
        this.supplier = supplier;
    }

    public void setCategory(Category category){
        this.category = category;
    }

    public void addInvoice(Invoice invoice) {
        this.invoices.add(invoice);
    }

    public Set<Invoice> getInvoices() {
        return this.invoices;
    }

    public Category getCategory(){
        return this.category;
    }

    @Override
    public String toString() {
        return "Product(ProductID: " + ProductID + ", ProductName: " + ProductName + ", UnitsInStock: " + UnitsInStock + ")";
    }
}
