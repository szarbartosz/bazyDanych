import com.mongodb.client.*;
import com.mongodb.client.model.*;
import org.bson.Document;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;

import static com.mongodb.client.model.Projections.*;
import static com.mongodb.client.model.Sorts.ascending;
import static com.mongodb.client.model.Filters.*;


public class MongoZad {
    MongoClient mongoClient = MongoClients.create();
    MongoDatabase db = mongoClient.getDatabase("BartoszSzar_wt1115_B");

    protected void zad_6_1a(){
        ArrayList<String> cities = db.getCollection("business").distinct("city", String.class).into(new ArrayList<>());
        Collections.sort(cities);

        for(String city: cities)
            System.out.println(city);
    }

    protected void zad_6_1b() {
        MongoCollection<Document> review = db.getCollection("review");
        System.out.println(review.countDocuments(Filters.gte("date", "2011-01-01")));
    }

    protected void zad_6_1c() {
        ArrayList<Document> business = db.getCollection("business")
                .find(new Document("open", false))
                .projection(fields(include("name", "full_address", "stars"), excludeId()))
                .into(new ArrayList<Document>());

        for(Document document: business)
            System.out.println(document.toJson());
    }

    protected void zad_6_1d() {
        ArrayList<Document> users = db.getCollection("user")
             .find(or(eq("votes.funny", 0), eq("votes.useful", 0)))
             .sort(ascending("name"))
             .into(new ArrayList<>());

        for(Document document: users)
            System.out.println(document.toJson());
    }

    protected void zad_6_1e() {
        ArrayList<Document> tips = db.getCollection("tip")
                .aggregate(Arrays.asList(
                        Aggregates.group("$business_id", Accumulators.sum("tips", 1))
                )).into(new ArrayList<>());

        for(Document document: tips)
            System.out.println(document.toJson());
    }

    protected void zad_6_1f() {
        ArrayList<Document> reviews = db.getCollection("review")
                .aggregate(Arrays.asList(
                        Aggregates.group("$business_id", Accumulators.avg("avg_rating", "$stars")),
                        Aggregates.match(Filters.gte("avg_rating", 4.0))
                )).into(new ArrayList<>());

        for(Document document: reviews)
            System.out.println(document.toJson());
    }

    protected void zad_6_1g() {
        db.getCollection("business").deleteMany(eq("stars", 2.0));
    }
}
