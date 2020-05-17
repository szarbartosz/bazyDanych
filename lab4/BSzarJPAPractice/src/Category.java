import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int CategoryID;
    private String Name;

    @OneToMany(cascade = CascadeType.PERSIST)
    @JoinColumn(name = "CategoryID_FK")
    private List<Product> products = new ArrayList<>();

    public Category(){}

    public Category(String Name){
        this.Name = Name;
    }

    public List<Product> getProducts(){
        return this.products;
    }

    @Override
    public String toString() {
        return "Category(CategoryID: " + CategoryID + ", CategoryName: " + Name + ")";
    }
}

