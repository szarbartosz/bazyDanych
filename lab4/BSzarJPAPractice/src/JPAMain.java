import org.hibernate.*;
import org.hibernate.cfg.Configuration;


import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.criteria.CriteriaBuilder;


public class JPAMain {

    public static void main(final String[] args) throws Exception {

        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myDatabaseConfig");
        EntityManager em = emf.createEntityManager();
        EntityTransaction etx = em.getTransaction();
        etx.begin();

        Supplier supplier1 = new Supplier("Heniek", "Zawiasowa", "Szuflandia", "32-512", "12345678900000");
        Supplier supplier2 = new Supplier("KrzysiekPOL", "Chmielowa", "Żywiec", "22-312", "00000123456789");
        Supplier supplier3 = new Supplier("JabłkoINC", "Sadowa", "Sadów", "32-612", "696969123456789");
        Customer customer1 = new Customer("Marian", "Szklana", "Denko", "13-312", 10);
        Customer customer2 = new Customer("PolINC", "Makrelowa", "Tychy", "37-313",  12);
        Customer customer3 = new Customer("StalBud", "Ceglana", "Pustakowo", "82-322", 69);

        em.persist(supplier1);
        em.persist(supplier2);
        em.persist(supplier3);
        em.persist(customer1);
        em.persist(customer2);
        em.persist(customer3);

        etx.commit();
        em.close();

    }
}